import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu.dart';
import 'repositories/literary_work_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

class LWOptionsScreen extends StatelessWidget {
  const LWOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Литературные произведения",
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
                    Navigator.pushReplacementNamed(context, "/lws/getAll"),
                child: const Text("Получить все литературные произведения")),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/lws/popular"),
                child: const Text(
                    "Получить популярные литературные произведения")),
            OutlinedButton(
                onPressed: () {},
                child: const Text("Добавить новое литературное произведение")),
          ],
        ));
  }
}

class LWAllScreen extends StatefulWidget {
  const LWAllScreen({super.key});

  @override
  State<LWAllScreen> createState() => _LWAllScreenState();
}

class _LWAllScreenState extends State<LWAllScreen> {
  final _lwRepository = LWRepository();
  late Future<List<LiteraryWork>> _lws;

  @override
  void initState() {
    super.initState();
    _lws = _lwRepository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Все литературные произведения",
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
      body: FutureBuilder<List<LiteraryWork>>(
        future: _lws,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: snapshot.data!
                  .map((lw) => SingleLWInfo(
                        lw: lw,
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

class SingleLWInfo extends StatelessWidget {
  final LiteraryWork _lw;
  final int? count;
  const SingleLWInfo({super.key, required lw, required this.count}) : _lw = lw;

  Widget _showIfCount(BuildContext context) {
    if (count == null) {
      return const Text("");
    }
    return Text("брали раз: $count",
        style: Theme.of(context).textTheme.bodyLarge);
  }

  Widget _showIfCategory(BuildContext context) {
    if (_lw.category == null) {
      return const Text("");
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(15.0),
          width: 800,
          child: Column(
            children: _lw.categoryInfo!
                .getTranslated()
                .entries
                .map((e) => Row(
                      children: [
                        Text("${e.key}: ",
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text("${e.value ?? "(нет)"}",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ))
                .toList(),
          )),
    );
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
                        "id: ${_lw.lwId}   ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(_lw.name,
                          style: Theme.of(context).textTheme.headlineMedium),
                      Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: _showIfCount(context)),
                    ],
                  )),
              Text("Авторы:", style: Theme.of(context).textTheme.bodyLarge),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15.0),
                    width: 800,
                    child: Column(
                      children: _lw.authors
                          .map((a) => Row(
                                children: [
                                  Text("authorId: ${a.authorId}   ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(
                                    "${a.lastName} ${a.firstName} ${a.patronymic ?? ""}",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ))
                          .toList(),
                    )),
              ),
              _showIfCategory(context),
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

class PopularLWScreen extends StatefulWidget {
  const PopularLWScreen({super.key});

  @override
  State<PopularLWScreen> createState() => _PopularLWScreenState();
}

class _PopularLWScreenState extends State<PopularLWScreen> {
  var _state = RequestWithParamsState.askingUser;
  final _lwRepository = LWRepository();
  late Future<List<Map<String, dynamic>>> _lws;
  String? _limit;
  late String _errorMessage;

  void _userReady() {
    setState(() {
      if (_limit == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указано количество";
        return;
      }
      var limit = int.parse(_limit!);
      if (limit <= 0) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не верно указано количество";
        return;
      }
      _state = RequestWithParamsState.showingInfo;
      _lws = _lwRepository.getPopular(limit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Популярные литературные произведения",
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
          RequestWithParamsState.showingInfo =>
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _lws,
              builder: (context, snapshot) {
                var isReady = snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done;

                if (isReady) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    children: snapshot.data!
                        .map((e) =>
                            SingleLWInfo(lw: e["lw"], count: e["count"] as int))
                        .toList(),
                  );
                }

                if (snapshot.hasError) {
                  return Text("Ошибка: ${snapshot.error?.toString()}");
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          RequestWithParamsState.askingUser => ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                children: [
                  Text(
                    "Количество",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextFormField(
                    showCursor: true,
                    style: Theme.of(context).textTheme.bodyLarge,
                    onChanged: (value) {
                      _limit = value;
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
                ]),
          RequestWithParamsState.errorInput => Center(
              child: Text(_errorMessage, style: errorStyle),
            ),
        });
  }
}
