import 'package:flutter/material.dart';
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
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/si/getAll"),
                child: const Text("Получить все хранимые экземпляры")),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/si/byLw"),
                child: const Text(
                    "Получить список инвентарных номеров и названий из библиотечного фонда, в которых содержится указанное произведение")),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/si/byAuthor"),
                child: const Text(
                    "Выдать список инвентарных номеров и названий из библиотечного фонда, в которых содержатся произведения указанного автора")),
            OutlinedButton(
                onPressed: () {},
                child: const Text("Добавить новый экземпляр")),
          ],
        ));
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
            return Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: getSITableRows(context, snapshot),
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

List<TableRow> getSITableRows(var context, var snapshot) {
  List<TableRow> tmp = [
    TableRow(children: [
      Text(
        "id экземпляра",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      Text(
        "id зала",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      Text(
        "номер шкафа",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      Text(
        "номер полки",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      Text(
        "можно ли выносить из библиотеки",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      Text(
        "максимальный срок выдачи (в днях)",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      Text(
        "дата поступления",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      Text(
        "дата списания",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ])
  ];
  for (var si in snapshot!.data) {
    var availableIssueWord = "";
    if (si.availableIssue) {
      availableIssueWord = "да";
    } else {
      availableIssueWord = "нет";
    }
    tmp.add(TableRow(
      children: [
        Text(
          "${si.storedId}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "${si.hallId}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "${si.bookcase}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "${si.shelf}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          availableIssueWord,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "${si.durationIssue}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          si.dateReceipt,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "${si.dateDispose ?? ""}",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    ));
  }
  return tmp;
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
                    return Table(
                      border: TableBorder.all(),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: getSITableRows(context, snapshot),
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
