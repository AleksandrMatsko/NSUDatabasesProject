import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Меню", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView(
        itemExtent: 50,
        padding: const EdgeInsets.all(5.0),
        children: [
          OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, "/"),
              child: const Text("Главная")),
          OutlinedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, "/authors"),
              child: const Text("Авторы")),
          OutlinedButton(
              onPressed: () {}, child: const Text("Литературные произведения")),
          OutlinedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, "/books"),
              child: const Text("Книги")),
          OutlinedButton(onPressed: () {}, child: const Text("Библиотеки")),
          OutlinedButton(onPressed: () {}, child: const Text("Библиотекари")),
          OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, "/ij"),
              child: const Text("Журнал выдачи")),
          OutlinedButton(onPressed: () {}, child: const Text("Читатели")),
          OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, "/rj"),
              child: const Text("Журнал регистрации")),
        ],
      ),
    );
  }
}

enum RequestWithParamsState { askingUser, showingInfo, errorInput }
