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
        ],
      ),
    );
  }
}
