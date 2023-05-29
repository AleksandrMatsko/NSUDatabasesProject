import 'package:flutter/material.dart';
import 'menu.dart';
import 'repositories/registration_journal_repository.dart';
import 'repositories/dtos.dart';

class RJAllScreen extends StatefulWidget {
  const RJAllScreen({super.key});

  @override
  State<RJAllScreen> createState() => _RJAllScreenState();
}

class _RJAllScreenState extends State<RJAllScreen> {
  final _rjRepository = RJRepository();
  late Future<List<RegistrationJournal>> _rj;

  @override
  void initState() {
    super.initState();
    _rj = _rjRepository.getAll();
  }

  List<DataColumn> _getRJColumns(BuildContext context) {
    return <DataColumn>[
      DataColumn(
        label: Text(
          "id читателя",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataColumn(
        label: Text(
          "фамилия читателя",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataColumn(
        label: Text(
          "дата регистрации",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataColumn(
        label: Text(
          "id библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataColumn(
        label: Text(
          "фамилия библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataColumn(
          label: Text(
        "id библиотеки",
        style: Theme.of(context).textTheme.bodyLarge,
      )),
    ];
  }

  List<DataRow> _getRJRows(BuildContext, var snapshot) {
    List<DataRow> res = [];
    for (var rj in snapshot!.data) {
      res.add(DataRow(
        cells: [
          DataCell(
            Text(
              "${rj.user.userId}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              rj.user.lastName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              rj.registrationDate,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              "${rj.librarian.librarianId}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              rj.librarian.lastName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              "${rj.library.libraryId}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Журнал регистрации",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext newBuildContext) {
                  return const Menu();
                }));
              },
              icon: const Icon(Icons.menu_rounded))
        ],
      ),
      body: FutureBuilder<List<RegistrationJournal>>(
        future: _rj,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return ListView(children: [
              DataTable(
                columns: _getRJColumns(context),
                rows: _getRJRows(context, snapshot),
              )
            ]);
          }

          if (snapshot.hasError) {
            return Text("Ошибка: ${snapshot.error?.toString()}");
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
