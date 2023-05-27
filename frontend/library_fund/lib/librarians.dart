import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu.dart';
import 'repositories/librarian_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

class LibrarianOptionsScreen extends StatelessWidget {
  const LibrarianOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Библиотекари",
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
                    Navigator.pushReplacementNamed(context, "/librns/getAll"),
                child: const Text("Получить всех библиотекарей")),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/librns/report"),
                child: const Text("Получить данные о выработке библиотекарей")),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/librns/byPlace"),
                child: const Text(
                    "Выдать список библиотекарей, работающих в указанном читальном зале некоторой библиотеки")),
            OutlinedButton(
                onPressed: () {},
                child: const Text("Добавить нового библиотекаря")),
          ],
        ));
  }
}

class LibrarariansAllScreen extends StatefulWidget {
  const LibrarariansAllScreen({super.key});

  @override
  State<LibrarariansAllScreen> createState() => _LibrarariansAllScreenState();
}

class _LibrarariansAllScreenState extends State<LibrarariansAllScreen> {
  final _librarianRepository = LibrarianRepository();
  late Future<List<Librarian>> _librns;

  @override
  void initState() {
    _librns = _librarianRepository.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Все библиотекари",
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
      body: FutureBuilder<List<Librarian>>(
        future: _librns,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: snapshot.data!
                  .map((librn) => SingleLibrarianInfo(
                        librn: librn,
                        count: null,
                      ))
                  .toList(),
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

class SingleLibrarianInfo extends StatelessWidget {
  final Librarian _librarian;
  final int? count;

  const SingleLibrarianInfo({super.key, required librn, required this.count})
      : _librarian = librn;

  Widget _showIfCount(BuildContext context) {
    if (count == null) {
      return const Text("");
    }
    return Text("обслужено читателей: $count",
        style: Theme.of(context).textTheme.bodyLarge);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: appBackgroundColor,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(15.0),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        "id библиотекаря: ${_librarian.librarianId}   ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                          "${_librarian.lastName} ${_librarian.firstName} ${_librarian.patronymic ?? ""}",
                          style: Theme.of(context).textTheme.headlineMedium),
                      Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: _showIfCount(context)),
                    ],
                  )),
              Text("Место работы:",
                  style: Theme.of(context).textTheme.bodyLarge),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15.0),
                    width: 800,
                    child: Text(
                        "зал с id: ${_librarian.hall.hallId}, \nбиблиотека: ${_librarian.hall.library.name}",
                        style: Theme.of(context).textTheme.bodyLarge)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              ])
            ]));
  }
}

class LibrariansReportScreen extends StatefulWidget {
  const LibrariansReportScreen({super.key});

  @override
  State<LibrariansReportScreen> createState() => _LibrariansReportScreenState();
}

class _LibrariansReportScreenState extends State<LibrariansReportScreen> {
  final _librarianRepository = LibrarianRepository();
  var _state = RequestWithParamsState.askingUser;
  late Future<List<Map<String, dynamic>>> _librns;
  late String _errorMessage;
  var _selectedDateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  void _userReady() {
    setState(() {
      var startDate = _selectedDateTimeRange.start;
      var endDate = _selectedDateTimeRange.end;
      if (startDate.isAfter(endDate)) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Начало периода должно быть раньше конца периода";
        return;
      }

      _librns = _librarianRepository.getReport(startDate, endDate);
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Отчёт о выработке библиотекарей",
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
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                      onPressed: () async {
                        final DateTimeRange? dateTimeRange =
                            await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (dateTimeRange != null) {
                          _selectedDateTimeRange = dateTimeRange;
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.calendar_today),
                        Text("Задать период")
                      ]),
                    )),
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
            FutureBuilder<List<Map<String, dynamic>>>(
                future: _librns,
                builder: (context, snapshot) {
                  var isReady = snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done;

                  if (isReady) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      children: snapshot.data!
                          .map((entry) => SingleLibrarianInfo(
                                librn: entry["librn"],
                                count: entry["numUsers"] as int,
                              ))
                          .toList(),
                    );
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

class LibrarianByPlaceScreen extends StatefulWidget {
  const LibrarianByPlaceScreen({super.key});

  @override
  State<LibrarianByPlaceScreen> createState() => _LibrarianByPlaceScreenState();
}

class _LibrarianByPlaceScreenState extends State<LibrarianByPlaceScreen> {
  final _librarianRepository = LibrarianRepository();
  var _state = RequestWithParamsState.askingUser;
  late Future<List<Librarian>> _librn;
  late String _errorMessage;
  String? _libName;
  String? _hallId;

  void _userReady() {
    setState(() {
      if (_libName == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указано название библиотеки";
        return;
      }
      if (_hallId == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан id зала";
        return;
      }

      _librn = _librarianRepository.getByPlace(_libName!, int.parse(_hallId!));
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Библиотекари работающие в указанном зале, указанной библиотеки",
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
                Text(
                  "Название библиотеки",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _libName = value;
                  },
                ),
                Text(
                  "id зала",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
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
          RequestWithParamsState.showingInfo => FutureBuilder<List<Librarian>>(
              future: _librn,
              builder: (context, snapshot) {
                var isReady = snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done;

                if (isReady) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    children: snapshot.data!
                        .map((librn) => SingleLibrarianInfo(
                              librn: librn,
                              count: null,
                            ))
                        .toList(),
                  );
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
