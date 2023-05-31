import 'package:flutter/material.dart';
import 'package:library_fund/books.dart';
import 'package:library_fund/librarians.dart';
import 'package:library_fund/libraries.dart';
import 'package:library_fund/literary_works.dart';
import 'package:library_fund/storage_info.dart';
import 'package:library_fund/users.dart';
import './utils/theme.dart';
import 'menu.dart';
import 'authors.dart';
import 'registration_journal.dart';
import 'issue_journal.dart';

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
      routes: {
        "/": (context) => const MainScreen(title: "Библиотечный фонд"),
        "/authors": (context) => const AuthorsOptionsScreen(),
        "/authors/getAll": (context) => const AuthorsAllScreen(),
        "/authors/addOne": (context) => const AuthorAddScreen(),
        "/books": (context) => const BookOptionsScreen(),
        "/books/getAll": (context) => const BooksAllScreen(),
        "/books/fromRegLib": (context) => const BooksFromLib(regLib: true),
        "/books/notFromRegLib": (context) => const BooksFromLib(regLib: false),
        "/books/place": (context) => const BookPlaceScreen(),
        "/books/flow": (context) => const BookFlowScreen(),
        "/books/addOne": (context) => const BookAddScreen(),
        "/rj": (context) => const RJAllScreen(),
        "/ij": (context) => const IJOptionsScreen(),
        "/ij/getAll": (context) => const IJAllScreen(),
        "/ij/addOne": (context) => const IJAddScreen(),
        "/ij/update": (context) => const IJUpdateScreen(),
        "/lws": (context) => const LWOptionsScreen(),
        "/lws/getAll": (context) => const LWAllScreen(),
        "/lws/popular": (context) => const PopularLWScreen(),
        "/lws/addOne": (context) => const LWCreateScreen(),
        "/libs": (context) => const LibraryOptionsScreen(),
        "/libs/getAll": (context) => const LibrariesAllScreen(),
        "/libs/addOne": (context) => const LibraryAddScreen(),
        "/si": (context) => const SIOptionsScreen(),
        "/si/getAll": (context) => const SIAllScreen(),
        "/si/byLw": (context) => const SIByTemplate(isLwTmp: true),
        "/si/byAuthor": (context) => const SIByTemplate(isLwTmp: false),
        "/si/addOne": (context) => const SIAddScreen(),
        "/si/update": (context) => const SIUpdateScreen(),
        "/librns": (context) => const LibrarianOptionsScreen(),
        "/librns/getAll": (context) => const LibrarariansAllScreen(),
        "/librns/report": (context) => const LibrariansReportScreen(),
        "/librns/byPlace": (context) => const LibrarianByPlaceScreen(),
        "/librns/addOne": (context) => const LibrarianAddScreen(),
        "/users": (context) => const UserOptionsScreen(),
        "/users/getAll": (context) => const UsersAllScreen(
              isOverdue: false,
            ),
        "/users/getByLwTmp": (context) => const UsersByTemplate(isLwTmp: true),
        "/users/getByBookTmp": (context) =>
            const UsersByTemplate(isLwTmp: false),
        "/users/overdue": (context) => const UsersAllScreen(isOverdue: true),
        "/users/byLwTmpAndPeriod": (context) => const UsersByLwAndPeriod(),
        "/users/byLibrarian": (context) => const UsersByLibrarian(),
        "/users/notVisit": (context) => const UsersNotVisitScreen(),
        "/users/addOne": (context) => const UserCreateScreen(),
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
