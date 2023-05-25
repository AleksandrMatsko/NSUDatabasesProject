import 'package:flutter/material.dart';
import 'menu.dart';
import 'repositories/author_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

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
                onPressed: () {}, child: const Text("Добавить нового автора")),
          ],
        ));
  }
}

class AuthorsAllScreen extends StatefulWidget {
  const AuthorsAllScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthorsAllScreenState();
}

class _AuthorsAllScreenState extends State<AuthorsAllScreen> {
  final _authorRepository = AuthorRepository();

  late Future<List<Author>> _authors;

  _AuthorsAllScreenState();

  @override
  void initState() {
    super.initState();
    _authors = _authorRepository.getAllAuthors();
  }

  @override
  Widget build(BuildContext context) {
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
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: snapshot.data!
                  .map((a) => SingleAuthorInfo(author: a))
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

class SingleAuthorInfo extends StatelessWidget {
  final Author _author;

  const SingleAuthorInfo({super.key, required author}) : _author = author;

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
                        "id: ${_author.authorId}   ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                          "${_author.lastName} ${_author.firstName} ${_author.patronymic ?? ""}",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  )),
              Text("Произведения:",
                  style: Theme.of(context).textTheme.bodyLarge),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15.0),
                    width: 800,
                    child: Column(
                      children: _author.literaryWorks
                          .map((lw) => Row(
                                children: [
                                  Text("lwId: ${lw.lwId}   ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(
                                    lw.name,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ))
                          .toList(),
                    )),
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
