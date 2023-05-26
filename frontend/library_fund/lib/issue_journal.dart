import 'package:flutter/material.dart';
import 'menu.dart';
import 'repositories/issue_journal_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

class IJOptionsScreen extends StatelessWidget {
  const IJOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Журнал выдачи",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext newBuildContext) {
                    return const Menu();
                  }));
                },
                icon: const Icon(Icons.menu_rounded))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          itemExtent: 50,
          children: [
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/ij/getAll"),
                child: const Text("Получить все записи")),
            OutlinedButton(
                onPressed: () {}, child: const Text("Добавить новогую запись")),
          ],
        ));
  }
}

class IJAllScreen extends StatefulWidget {
  const IJAllScreen({super.key});

  @override
  State<IJAllScreen> createState() => _IJAllScreenState();
}

class _IJAllScreenState extends State<IJAllScreen> {
  final _ijRepository = IJRepository();
  late Future<List<IssueJournal>> _ij;

  @override
  void initState() {
    super.initState();
    _ij = _ijRepository.getAll();
  }

  List<TableRow> _getTableRows(var context, var snapshot) {
    List<TableRow> tmp = [
      TableRow(children: [
        Text(
          "инвентарный номер",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "максимальный срок выдачи (в днях)",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "дата выдачи",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "дата возврата",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "id читателя",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "фамилия читателя",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "id выдавшего библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "фамилия выдавшего библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "id принявшего библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "фамилия принявшего библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ])
    ];
    for (var ij in snapshot!.data) {
      String acceptedById = "";
      String acceptedByLastName = "";
      if (ij.acceptedBy != null) {
        acceptedById = ij.acceptedBy.librarianId.toString();
        acceptedByLastName = ij.acceptedBy.lastName;
      }
      String dateReturn = "";
      if (ij.dateReturn != null) {
        dateReturn = ij.dateReturn;
      }

      tmp.add(TableRow(
        children: [
          Text(
            "${ij.stored.storedId}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            "${ij.stored.durationIssue}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            ij.dateIssue,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            dateReturn,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            "${ij.user.userId}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            ij.user.lastName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            "${ij.issuedBy.librarianId}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            ij.issuedBy.lastName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            acceptedById,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            acceptedByLastName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: appSecondaryColor,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit_note_sharp,
                color: appSecondaryColor,
              )),
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
          "Журнал выдачи",
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
      body: FutureBuilder<List<IssueJournal>>(
        future: _ij,
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
