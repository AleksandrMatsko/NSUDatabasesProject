import 'package:flutter/material.dart';
import './utils/theme.dart';
import 'menu.dart';
import 'authors.dart';

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
      //home: const MyMainWidget(title: "Библиотечный фонд"),
      routes: {
        "/": (context) => const MainScreen(title: "Библиотечный фонд"),
        "/authors": (context) => const AuthorsOptionsScreen(),
        "/authors/getAll": (context) => const AuthorsAllScreen(),
      },
      initialRoute: "/",
    );
  }
}

class MainScreen extends StatelessWidget {
  final String title;
  const MainScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
        body: const Text("Проект по курсу базы данных."));
  }
}
