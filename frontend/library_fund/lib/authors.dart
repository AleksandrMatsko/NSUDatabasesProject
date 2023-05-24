import 'package:flutter/material.dart';
import 'menu.dart';
import 'repositories/author_repository.dart';

class AuthorsOptionsScreen extends StatelessWidget {
  const AuthorsOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Авторы",
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
                    Navigator.pushReplacementNamed(context, "/authors/getAll"),
                child: const Text("Получить всех авторов")),
            OutlinedButton(
                onPressed: () {}, child: const Text("Добавить новых авторов")),
          ],
        ));
  }
}

class AuthorsAllScreen extends StatefulWidget {
  const AuthorsAllScreen({super.key});

  @override
  State<StatefulWidget> createState() => AuthorsAllScreenState();
}

enum _AllScreenState { loading, ready }

class AuthorsAllScreenState extends State<AuthorsAllScreen> {
  var _state = _AllScreenState.loading;
  final _authorRepository = AuthorRepository();

  late Future<List<Author>> _authors;

  AuthorsAllScreenState();

  @override
  void initState() {
    super.initState();
    _authors = _authorRepository.getAuthorsList().then((value) {
      onComplete();
      return value;
    });
  }

  void onComplete() {
    setState(() {
      _state = _AllScreenState.ready;
    });
  }

  @override
  Widget build(BuildContext context) {
    var authors = AuthorRepository().getAuthorsList();
    debugPrint(authors.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Все авторы",
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
      body: FutureBuilder<List<Author>>(
        future: _authors,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return Text(snapshot.data!.toString());
          }

          if (snapshot.hasError) {
            return Text("Ошибка: ${snapshot.error?.toString()}");
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
