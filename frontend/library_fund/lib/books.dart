import 'package:flutter/material.dart';
import 'menu.dart';
import 'repositories/book_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

class BookOptionsScreen extends StatelessWidget {
  const BookOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Книги",
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
                    Navigator.pushReplacementNamed(context, "/books/getAll"),
                child: const Text("Получить все книги")),
            OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, "/books/fromRegLib"),
                child: const Text(
                    "Выдать список изданий, которые в течение некоторого времени получал указанный читатель из фонда библиотеки, где он зарегистрирован")),
            OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, "/books/notFromRegLib"),
                child: const Text(
                    "Получить перечень изданий, которыми в течение некоторого времени пользовался указанный читатель из фонда библиотеки, где он не зарегистрирован")),
            OutlinedButton(
                onPressed: () {},
                child: const Text(
                    "Получить список литературы, которая в настоящий момент выдана с определенной полки некоторой библиотеки")),
            OutlinedButton(
                onPressed: () {},
                child: const Text(
                    "Получить перечень указанной литературы, которая поступила (была списана) в течение некоторого периода")),
            OutlinedButton(
                onPressed: () {}, child: const Text("Добавить новую книгу")),
          ],
        ));
  }
}

class BooksAllScreen extends StatefulWidget {
  const BooksAllScreen({super.key});

  @override
  State<BooksAllScreen> createState() => _BooksAllScreenState();
}

class _BooksAllScreenState extends State<BooksAllScreen> {
  final _bookRepository = BookRepository();

  late Future<List<Book>> _books;

  _BooksAllScreenState();

  @override
  void initState() {
    super.initState();
    _books = _bookRepository.getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Все книги",
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
      body: FutureBuilder<List<Book>>(
        future: _books,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children:
                  snapshot.data!.map((a) => SingleBookInfo(book: a)).toList(),
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

class SingleBookInfo extends StatelessWidget {
  final Book _book;

  const SingleBookInfo({super.key, required book}) : _book = book;

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
                        "id: ${_book.bookId}   ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(_book.name,
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
                      children: _book.literaryWorks
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

class BooksFromLib extends StatefulWidget {
  final bool regLib;
  const BooksFromLib({super.key, required this.regLib});

  @override
  State<BooksFromLib> createState() => _BooksFromLibState(regLib: regLib);
}

class _BooksFromLibState extends State<BooksFromLib> {
  final bool regLib;
  final _bookRepository = BookRepository();
  var _state = RequestWithParamsState.askingUser;
  late Future<List<Book>> _books;
  late String _userLastName;
  late String _errorMessage;
  var _selectedDateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  _BooksFromLibState({required this.regLib});

  void _onUserLastNameSubmitted(dynamic value) {
    _userLastName = value;
  }

  void _userReady() {
    setState(() {
      var startDate = _selectedDateTimeRange.start;
      var endDate = _selectedDateTimeRange.end;
      if (startDate.isAfter(endDate)) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Начало периода должно быть раньше конца периода";
        return;
      }

      _state = RequestWithParamsState.showingInfo;
      _books = _bookRepository.getBooksFromLib(
          regLib, _userLastName, startDate, endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Все книги",
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: [
                Text("Фамилия читателя",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onFieldSubmitted: (value) => _onUserLastNameSubmitted(value),
                ),
                FilledButton(
                  onPressed: () async {
                    final DateTimeRange? dateTimeRange =
                        await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now());
                    if (dateTimeRange != null) {
                      _selectedDateTimeRange = dateTimeRange;
                    }
                  },
                  child: const Row(children: [
                    Icon(Icons.calendar_today),
                    Text("Задать период")
                  ]),
                ),
                FilledButton(
                    onPressed: _userReady,
                    child: const Row(
                      children: [Icon(Icons.search), Text("Искать")],
                    ))
              ],
            ),
          RequestWithParamsState.showingInfo => FutureBuilder<List<Book>>(
              future: _books,
              builder: (context, snapshot) {
                var isReady = snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done;

                if (isReady) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    children: snapshot.data!
                        .map((a) => SingleBookInfo(book: a))
                        .toList(),
                  );
                }

                if (snapshot.hasError) {
                  return Text("Ошибка: ${snapshot.error?.toString()}");
                }

                return const Center(child: CircularProgressIndicator());
              }),
          RequestWithParamsState.errorInput => Center(
              child: Text(_errorMessage, style: errorStyle),
            )
        });
  }
}