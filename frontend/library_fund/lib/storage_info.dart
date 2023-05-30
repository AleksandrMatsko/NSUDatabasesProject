import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'menu.dart';
import 'repositories/storage_info_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

class SIOptionsScreen extends StatelessWidget {
  const SIOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Хранимые экземпляры",
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
                onPressed: () => Navigator.pushNamed(context, "/si/getAll"),
                child: const Text("Получить все хранимые экземпляры")),
            OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, "/si/byLw"),
                child: const Text(
                    "Получить список инвентарных номеров и названий из библиотечного фонда, в которых содержится указанное произведение")),
            OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, "/si/byAuthor"),
                child: const Text(
                    "Выдать список инвентарных номеров и названий из библиотечного фонда, в которых содержатся произведения указанного автора")),
            OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, "/si/addOne"),
                child: const Text("Добавить новый экземпляр")),
          ],
        ));
  }
}

class SIAddScreen extends StatefulWidget {
  const SIAddScreen({super.key});

  @override
  State<SIAddScreen> createState() => _SIAddScreenState();
}

class _SIAddScreenState extends State<SIAddScreen> {
  final _siRepository = SIRepository();
  late Future<bool> _success;
  var _state = RequestWithParamsState.askingUser;
  late String _errorMessage;
  String? _bookId;
  String? _hallId;
  String? _bookcase;
  String? _shelf;
  bool? _availableIssue = true;
  String? _durationIssue;
  DateTime? _dateReceipt;
  DateTime? _dateDispose;

  void _userReady() {
    setState(() {
      if (_bookId == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан id книги";
        return;
      }
      if (_hallId == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан id зала";
        return;
      }
      if (_bookcase == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан номер книжного шкафа";
        return;
      }
      if (_shelf == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан номер полки";
        return;
      }
      if (_durationIssue == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указана длительность выдачи";
        return;
      }
      if (_dateReceipt == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указана дата получения экземпляра";
        return;
      }

      initializeDateFormatting();
      DateFormat formatter = DateFormat(dateTemplate);
      String receiptDate = formatter.format(_dateReceipt!);
      String? disposeDate;
      if (_dateDispose != null) {
        disposeDate = formatter.format(_dateDispose!);
      }

      _success = _siRepository.create({
        "bookId": int.parse(_bookId!),
        "hallId": int.parse(_hallId!),
        "bookcase": int.parse(_bookcase!),
        "shelf": int.parse(_shelf!),
        "availableIssue": _availableIssue!,
        "durationIssue": int.parse(_durationIssue!),
        "dateReceipt": receiptDate,
        "dateDispose": disposeDate,
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
            "Добавление хранимого экземпляра",
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
                Text("id книги", style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _bookId = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Text("id зала", style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _hallId = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Text("Номер книжного шкафа",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _bookcase = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Text("Номер полки",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _shelf = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Text("Возможность выноса из библиотеки",
                    style: Theme.of(context).textTheme.bodyLarge),
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Checkbox(
                      value: _availableIssue,
                      onChanged: (value) {
                        setState(() {
                          _availableIssue = value;
                        });
                      }),
                ),
                Text("Длительность выдачи (в днях)",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _durationIssue = value;
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
                          _dateReceipt = dateTime;
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.calendar_today),
                        Text("Задать дату получения")
                      ]),
                    )),
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
                          _dateDispose = dateTime;
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.calendar_today),
                        Text("Задать дату списания")
                      ]),
                    )),
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
                        child: Text("Экземпляр добавлен",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      FilledButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, "/si"),
                          child: const Text("Меню экземляров")),
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

class SIAllScreen extends StatefulWidget {
  const SIAllScreen({super.key});

  @override
  State<SIAllScreen> createState() => _SIAllScreenState();
}

class _SIAllScreenState extends State<SIAllScreen> {
  final _siRepository = SIRepository();
  late Future<List<StorageInfo>> _si;

  @override
  void initState() {
    _si = _siRepository.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Все хранимые экземпляры",
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
      body: FutureBuilder<List<StorageInfo>>(
        future: _si,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: getSITableColumns(context),
                      rows: getSITableRows(context, snapshot, _siRepository),
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

List<DataColumn> getSITableColumns(BuildContext context) {
  return <DataColumn>[
    DataColumn(
      label: Text(
        "id экземпляра",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "id зала",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "номер шкафа",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "номер полки",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "id книги",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "название книги",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "можно ли выносить\nиз библиотеки",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "максимальный срок\nвыдачи (в днях)",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "дата поступления",
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    DataColumn(
      label: Text(
        "дата списания",
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

List<DataRow> getSITableRows(
    BuildContext context, var snapshot, SIRepository siRepository) {
  List<DataRow> res = [];
  for (var si in snapshot!.data!) {
    var availableIssueWord = "";
    if (si.availableIssue) {
      availableIssueWord = "да";
    } else {
      availableIssueWord = "нет";
    }
    res.add(DataRow(cells: [
      DataCell(
        Text(
          "${si.storedId}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataCell(
        Text(
          "${si.hallId}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataCell(
        Text(
          "${si.bookcase}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataCell(
        Text(
          "${si.shelf}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataCell(
        Text(
          "${si.book.bookId}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataCell(
        Text(
          "${si.book.name}",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          availableIssueWord,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataCell(
        Text(
          "${si.durationIssue}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataCell(
        Text(
          si.dateReceipt,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      DataCell(Text(
        "${si.dateDispose ?? ""}",
        style: Theme.of(context).textTheme.bodyLarge,
      )),
      DataCell(
        IconButton(
            onPressed: () {
              siRepository.deleteById(si.storedId);
              Navigator.pushReplacementNamed(context, "/si");
            },
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
    ]));
  }
  return res;
}

class SIByTemplate extends StatefulWidget {
  final bool isLwTmp;
  const SIByTemplate({super.key, required this.isLwTmp});

  @override
  State<SIByTemplate> createState() => _SIByTemplateState(isLwTmp: isLwTmp);
}

class _SIByTemplateState extends State<SIByTemplate> {
  final bool isLwTmp;
  final _siRepository = SIRepository();
  late Future<List<StorageInfo>> _si;
  var _state = RequestWithParamsState.askingUser;
  String? _template;
  late String _errorMessage;

  _SIByTemplateState({required this.isLwTmp});

  void _onTmpChanged(dynamic value) {
    _template = value;
  }

  void _userReady() {
    setState(() {
      if (_template == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Шаблон не введён";
        return;
      }

      _si = _siRepository.getByTmp(isLwTmp, _template!);
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    String paramName;
    if (isLwTmp) {
      title =
          "Инвентарные номера и названия, в которых содержится указанное произведение";
      paramName = "Название произведения";
    } else {
      title =
          "Инвентарные номера и названия, в которых содержатся произведения указанного автора";
      paramName = "Фамилия автора";
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            title,
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
                Text(paramName, style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) => _onTmpChanged(value),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                        onPressed: _userReady,
                        child: const Row(
                          children: [Icon(Icons.search), Text("Искать")],
                        ))),
              ],
            ),
          RequestWithParamsState.showingInfo =>
            FutureBuilder<List<StorageInfo>>(
                future: _si,
                builder: (context, snapshot) {
                  var isReady = snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done;

                  if (isReady) {
                    return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: getSITableColumns(context),
                              rows: getSITableRows(
                                  context, snapshot, _siRepository),
                            )));
                  }

                  if (snapshot.hasError) {
                    return Text("Ошибка: ${snapshot.error?.toString()}");
                  }

                  return const Center(child: CircularProgressIndicator());
                }),
          RequestWithParamsState.errorInput => Center(
              child: Text(_errorMessage, style: errorStyle),
            )
        });
  }
}
