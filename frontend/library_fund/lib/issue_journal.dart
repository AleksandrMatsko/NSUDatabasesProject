import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/ij/addOne"),
                child: const Text("Добавить новогую запись")),
          ],
        ));
  }
}

class IJAddScreen extends StatefulWidget {
  const IJAddScreen({super.key});

  @override
  State<IJAddScreen> createState() => _IJAddScreenState();
}

class _IJAddScreenState extends State<IJAddScreen> {
  final _ijRepository = IJRepository();
  late Future<bool> _success;
  var _state = RequestWithParamsState.askingUser;
  late String _errorMessage;
  String? _storedId;
  String? _userId;
  String? _issuedBy;
  String? _acceptedBy;
  DateTime? _dateIssue;
  DateTime? _dateReturn;

  void _userReady() {
    setState(() {
      if (_storedId == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан id выдаваемого экземпляра";
        return;
      }
      if (_userId == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан id читателя, взявшего книгу";
        return;
      }
      if (_issuedBy == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан id выдавшего библиотекаря";
        return;
      }
      if (_dateIssue == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указана дата выдачи";
        return;
      }

      initializeDateFormatting();
      DateFormat formatter = DateFormat(dateTemplate);
      String issueDate = formatter.format(_dateIssue!);
      String? returnDate;
      int? acceptedBy;
      if (_dateReturn != null && _acceptedBy != null) {
        returnDate = formatter.format(_dateReturn!);
        acceptedBy = int.parse(_acceptedBy!);
      }

      _success = _ijRepository.create({
        "storedId": int.parse(_storedId!),
        "userId": int.parse(_userId!),
        "dateIssue": issueDate,
        "dateReturn": returnDate,
        "issuedBy": int.parse(_issuedBy!),
        "acceptedBy": acceptedBy,
      });
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Добавление записи в журнал выдачи",
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
        body: switch (_state) {
          RequestWithParamsState.askingUser => ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              children: [
                Text("id экземпляра",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _storedId = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Text("id читателя",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _userId = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                      onPressed: () async {
                        final DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (dateTime != null) {
                          _dateIssue = dateTime;
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.calendar_today),
                        Text("Задать дату выдачи")
                      ]),
                    )),
                Text("id выдавшего библиотекаря",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _issuedBy = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                      onPressed: () async {
                        final DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (dateTime != null) {
                          _dateReturn = dateTime;
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.calendar_today),
                        Text("Задать дату возврата")
                      ]),
                    )),
                Text("id принявшего библиотекаря",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _acceptedBy = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                        onPressed: _userReady,
                        child: const Row(
                          children: [Text("Добавить")],
                        ))),
              ],
            ),
          RequestWithParamsState.showingInfo => FutureBuilder<bool>(
              future: _success,
              builder: (context, snapshot) {
                var isReady = snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done;

                if (isReady && snapshot.data!) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text("Запись добавлена",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      FilledButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, "/ij"),
                          child: const Text("Меню журнала выдачи")),
                    ]),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Ошибка: ${snapshot.error?.toString()}",
                    style: errorStyle,
                  ));
                }

                if (isReady && !snapshot.data!) {
                  return const Center(
                      child: Text(
                    "Ошибка: что-то пошло не так",
                    style: errorStyle,
                  ));
                }

                return const Center(child: CircularProgressIndicator());
              }),
          RequestWithParamsState.errorInput => Center(
              child: Text(_errorMessage, style: errorStyle),
            )
        });
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

  List<DataColumn> _getIJColumns(BuildContext context) {
    return <DataColumn>[
      DataColumn(
        label: Text(
          "инвентарный номер",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "максимальный срок выдачи (в днях)",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "дата выдачи",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "дата возврата",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "id читателя",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "фамилия читателя",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "id выдавшего библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "фамилия выдавшего библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "id принявшего библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "фамилия принявшего библиотекаря",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataColumn(
        label: Text(
          "",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];
  }

  List<DataRow> _getIJRows(BuildContext context, var snapshot) {
    List<DataRow> res = [];
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

      res.add(DataRow(
        cells: [
          DataCell(
            Text(
              "${ij.stored.storedId}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              "${ij.stored.durationIssue}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              ij.dateIssue,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              dateReturn,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              "${ij.user.userId}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              ij.user.lastName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              "${ij.issuedBy.librarianId}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              ij.issuedBy.lastName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              acceptedById,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            Text(
              acceptedByLastName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DataCell(
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: appSecondaryColor,
                )),
          ),
          DataCell(
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit_note_sharp,
                  color: appSecondaryColor,
                )),
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
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: _getIJColumns(context),
                      rows: _getIJRows(context, snapshot),
                    )));
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
