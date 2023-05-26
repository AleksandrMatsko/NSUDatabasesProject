import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'menu.dart';
import 'repositories/registration_journal_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

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

  List<TableRow> _getTableRows(var context, var snapshot) {
    List<TableRow> tmp = [
      TableRow(children: [
        Text(
          "id читателя",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "фамилия читателя",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "дата регистрации",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "id библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "фамилия библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "id библиотеки",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ])
    ];
    for (var rj in snapshot!.data) {
      tmp.add(TableRow(
        children: [
          Text(
            "${rj.user.userId}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            rj.user.lastName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            rj.registrationDate,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            "${rj.librarian.librarianId}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            rj.librarian.lastName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            "${rj.library.libraryId}",
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ));
    }
    return tmp;
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
            return Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: _getTableRows(context, snapshot),
            );
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

class SingleRJRecord extends TableRow {
  final RegistrationJournal rj;

  const SingleRJRecord({super.key, required this.rj});

  TableRow build(BuildContext context) {
    return TableRow(
      children: [
        Text(
          "${rj.user.userId}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          rj.user.lastName,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          rj.registrationDate,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "${rj.librarian.librarianId}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          rj.librarian.lastName,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "${rj.library.libraryId}",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}

class SingleRJRecord_ extends StatelessWidget {
  final RegistrationJournal rj;

  const SingleRJRecord_({super.key, required this.rj});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: appBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${rj.user.userId}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              rj.user.lastName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              rj.registrationDate,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "${rj.librarian.librarianId}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              rj.librarian.lastName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "${rj.library.libraryId}",
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ));
  }
}
