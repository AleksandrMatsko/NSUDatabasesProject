import 'package:flutter/material.dart';
import './utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Fund',
      theme: basicTheme(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const MyInfoWidget(title: "Библиотечный фонд"),
    );
  }
}

class MyInfoWidget extends StatefulWidget {
  const MyInfoWidget({super.key, required this.title});

  final String title;

  @override
  State<MyInfoWidget> createState() => _MyInfoWidgetState();
}

class _MyInfoWidgetState extends State<MyInfoWidget> {
  String _widgetKey = "main";
  List<String> _widgetKeys = ["main", "authors", "books"];

  void authorPressed() {
    setState(() {
      _widgetKey = "authors";
    });
  }

  void bookPressed() {
    setState(() {
      _widgetKey = "books";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            width: 100,
            height: 200,
            child: ListView(
              itemExtent: 50,
              children: [
                TextButton(
                  onPressed: authorPressed,
                  child: const Text("Авторы"),
                ),
                TextButton(onPressed: bookPressed, child: const Text("Книги")),
              ],
            ),
          ),
          switch (_widgetKeys.indexOf(_widgetKey)) {
            1 => const AuthorsInfoWidget(),
            _ => Text(
                _widgetKey,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
          },
        ],
      ),
    );
  }
}

class AuthorsInfoWidget extends StatefulWidget {
  final String _widgetKey = "authors";

  const AuthorsInfoWidget({super.key});

  String getKey() {
    return _widgetKey;
  }

  @override
  State<StatefulWidget> createState() => _AuthorInfoWidgetState();
}

class _AuthorInfoWidgetState extends State<AuthorsInfoWidget> {
  void getAllPressed() {
    setState(() {
      return;
    });
  }

  void addOnePressed() {
    setState(() {
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 300,
      height: 100,
      child: ListView(
        itemExtent: 50,
        children: [
          OutlinedButton(
              onPressed: getAllPressed,
              child: const Text("Получить всех авторов")),
          OutlinedButton(
              onPressed: addOnePressed, child: const Text("Добавить автора")),
        ],
      ),
    );
  }
}
