import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu.dart';
import 'repositories/user_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

class UserOptionsScreen extends StatelessWidget {
  const UserOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Читатели",
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
                    Navigator.pushReplacementNamed(context, "/users/getAll"),
                child: const Text("Получить всех читателей")),
            OutlinedButton(
                onPressed: () {},
                child: const Text(
                    "Выдать перечень читателей, на руках у которых находится указанное произведение")),
            OutlinedButton(
                onPressed: () {},
                child: const Text(
                    "Получить список читателей, на руках у которых находится указанное издание (книга, журнал и т.д)")),
            OutlinedButton(
                onPressed: () {},
                child: const Text(
                    "Получить перечень читателей, которые в течение указанного промежутка времени получали издание с некоторым произведением, и название этого издания")),
            OutlinedButton(
                onPressed: () {},
                child: const Text(
                    "Выдать список читателей, которые в течение обозначенного периода были обслужены указанным библиотекарем")),
            OutlinedButton(
                onPressed: () {},
                child: const Text(
                    "Получить список читателей с просроченным сроком литературы.")),
            OutlinedButton(
                onPressed: () {},
                child: const Text(
                    "Получить список читателей, не посещавших библиотеку в течение указанного времени")),
            OutlinedButton(
                onPressed: () {},
                child: const Text("Добавить нового читателя")),
          ],
        ));
  }
}

class UsersAllScreen extends StatefulWidget {
  const UsersAllScreen({super.key});

  @override
  State<UsersAllScreen> createState() => _UsersAllScreenState();
}

class _UsersAllScreenState extends State<UsersAllScreen> {
  final _userRepository = UserRepository();

  late Future<List<User>> _users;

  @override
  void initState() {
    _users = _userRepository.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Все читатели",
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
      body: FutureBuilder<List<User>>(
        future: _users,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: snapshot.data!
                  .map((u) => SingleUserInfo(
                        user: u,
                        book: null,
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

class SingleUserInfo extends StatelessWidget {
  final User _user;
  final ShortBook? _book;
  const SingleUserInfo({super.key, required user, required book})
      : _user = user,
        _book = book;

  Widget _showIfBook(BuildContext context) {
    if (_book == null) {
      return const Text("");
    }
    return Text("встречаетсв: ${_book!.name} (id книги: ${_book!.bookId})",
        style: Theme.of(context).textTheme.bodyLarge);
  }

  Widget _showIfCategory(BuildContext context) {
    if (_user.category == null) {
      return const Text("");
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(15.0),
          width: 800,
          child: Column(
            children: _user.categoryInfo!
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
                        "id читателя: ${_user.userId}   ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                          "${_user.lastName} ${_user.firstName} ${_user.patronymic ?? ""}",
                          style: Theme.of(context).textTheme.headlineMedium),
                      Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: _showIfBook(context)),
                    ],
                  )),
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
