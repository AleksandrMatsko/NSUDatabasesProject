import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu.dart';
import 'repositories/library_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

class LibraryOptionsScreen extends StatelessWidget {
  const LibraryOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Библиотеки",
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
                onPressed: () => Navigator.pushNamed(context, "/libs/getAll"),
                child: const Text("Получить все библиотеки")),
            OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, "/libs/addOne"),
                child: const Text("Добавить новую библиотеку")),
          ],
        ));
  }
}

class LibraryAddScreen extends StatefulWidget {
  const LibraryAddScreen({super.key});

  @override
  State<LibraryAddScreen> createState() => _LibraryAddScreenState();
}

class _LibraryAddScreenState extends State<LibraryAddScreen> {
  final _libRepository = LibraryRepository();
  late Future<bool> _success;
  var _state = RequestWithParamsState.askingUser;
  late String _errorMessage;
  String? _name;
  String? _district;
  String? _street;
  String? _building;
  String? _numHalls;

  void _userReady() {
    setState(() {
      if (_name == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указано название библиотеки";
        return;
      }
      if (_district == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан район расположения";
        return;
      }
      if (_street == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указана улица";
        return;
      }
      if (_building == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан номер дома";
        return;
      }
      if (_numHalls == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указано число залов";
        return;
      }

      _success = _libRepository.create({
        "name": _name!,
        "district": _district!,
        "street": _street!,
        "building": _building!,
        "numHalls": int.parse(_numHalls!),
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
            "Добавление библиотеки",
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
                Text("Название библиотеки",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                Text("Район", style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _district = value;
                  },
                ),
                Text("Улица", style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _street = value;
                  },
                ),
                Text("Номер дома",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _building = value;
                  },
                ),
                Text("Количество залов",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _numHalls = value;
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
                        child: Text("Библиотека добавлена",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      FilledButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, "/libs"),
                          child: const Text("Меню библиотек")),
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

class LibrariesAllScreen extends StatefulWidget {
  const LibrariesAllScreen({super.key});

  @override
  State<LibrariesAllScreen> createState() => _LibrariesAllScreenState();
}

class _LibrariesAllScreenState extends State<LibrariesAllScreen> {
  final _libRepository = LibraryRepository();
  late Future<List<Library>> _libs;

  @override
  void initState() {
    _libs = _libRepository.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Все библиотеки",
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
      body: FutureBuilder<List<Library>>(
        future: _libs,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: snapshot.data!
                  .map((lib) => SingleLibraryInfo(lib: lib))
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

class SingleLibraryInfo extends StatelessWidget {
  final Library _library;

  const SingleLibraryInfo({super.key, required lib}) : _library = lib;

  Widget _hallInfo(BuildContext context, LibHall h) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: appSecondaryColor),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: 600,
            child: Text("id зала: ${h.hallId}",
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          Container(
              alignment: Alignment.center,
              width: 600,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                    children: h.librarians
                        .map((librn) => Text(
                            "librarianId: ${librn.librarianId}    ${librn.lastName} ${librn.firstName} ${librn.patronymic ?? ""}",
                            style: Theme.of(context).textTheme.bodyLarge))
                        .toList()),
              ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: appBackgroundColor,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        "id: ${_library.libraryId}   ${_library.name}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(10.0),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        "адрес:   ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                          "${_library.district} район, ул. ${_library.street} д. ${_library.building}",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  )),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                height: 65 * (_library.halls.length + 1),
                child: Column(
                  children:
                      _library.halls.map((h) => _hallInfo(context, h)).toList(),
                ),
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
