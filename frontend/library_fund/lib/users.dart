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
                onPressed: () => Navigator.pushReplacementNamed(
                    context, "/users/getByLwTmp"),
                child: const Text(
                    "Выдать перечень читателей, на руках у которых находится указанное произведение")),
            OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, "/users/getByBookTmp"),
                child: const Text(
                    "Получить список читателей, на руках у которых находится указанное издание (книга, журнал и т.д)")),
            OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, "/users/byLwTmpAndPeriod"),
                child: const Text(
                    "Получить перечень читателей, которые в течение указанного промежутка времени получали издание с некоторым произведением, и название этого издания")),
            OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, "/users/byLibrarian"),
                child: const Text(
                    "Выдать список читателей, которые в течение обозначенного периода были обслужены указанным библиотекарем")),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/users/overdue"),
                child: const Text(
                    "Получить список читателей с просроченным сроком литературы.")),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/users/notVisit"),
                child: const Text(
                    "Получить список читателей, не посещавших библиотеку в течение указанного времени")),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/users/addOne"),
                child: const Text("Добавить нового читателя")),
          ],
        ));
  }
}

class UserCreateScreen extends StatefulWidget {
  const UserCreateScreen({super.key});

  @override
  State<UserCreateScreen> createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends State<UserCreateScreen> {
  final _userRepository = UserRepository();
  late Future<bool> _success;
  var _state = RequestWithParamsState.askingUser;
  late String _errorMessage;
  String? _lastName;
  String? _firstName;
  String? _patronymic;
  String? _librarianId;

  var _category = UserCategories.none;
  Map<String, String?> _formParams = {};

  UserCategoryInfo? _getCategoryInfo() {
    if (_formParams.isEmpty) {
      return null;
    }
    switch (_category) {
      case (UserCategories.scientist):
        {
          return Scientist.fromJson(_formParams);
        }
      case (UserCategories.student):
        {
          return Student.fromJson(_formParams);
        }
      case (UserCategories.worker):
        {
          return Worker.fromJson(_formParams);
        }
      case (UserCategories.teacher):
        {
          return Teacher.fromJson(_formParams);
        }
      case (UserCategories.pupil):
        {
          return Pupil.fromJson(_formParams);
        }
      case (UserCategories.pensioner):
        {
          return Pensioner.fromJson(_formParams);
        }
      default:
        {
          return null;
        }
    }
  }

  Widget _getFormByCategory(BuildContext context, UserCategories category) {
    switch (_category) {
      case (UserCategories.scientist):
        {
          _formParams = {
            "degree": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Учёная степень",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["degree"] = value;
                },
              ),
            ],
          );
        }
      case (UserCategories.student):
        {
          _formParams = {
            "faculty": null,
            "university": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Университет",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["university"] = value;
                },
              ),
              Text(
                "Факультет",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["faculty"] = value;
                },
              ),
            ],
          );
        }
      case (UserCategories.worker):
        {
          _formParams = {
            "job": null,
            "company": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Компания",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["company"] = value;
                },
              ),
              Text(
                "Должность",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["job"] = value;
                },
              ),
            ],
          );
        }
      case (UserCategories.teacher):
        {
          _formParams = {
            "school": null,
            "subject": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Школа",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["school"] = value;
                },
              ),
              Text(
                "Преподаваемый предмет",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["subject"] = value;
                },
              ),
            ],
          );
        }
      case (UserCategories.pupil):
        {
          _formParams = {
            "school": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Школа",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["school"] = value;
                },
              ),
            ],
          );
        }
      case (UserCategories.pensioner):
        {
          _formParams = {
            "discount": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Скидка",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["discount"] = value;
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ],
          );
        }
      default:
        {
          _formParams = {};
          return const Text("");
        }
    }
  }

  ChoiceChip getChoiceChip(
      String desc, Function isSelected, Function onSelected) {
    return ChoiceChip(
        label: Text(
          desc,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        selected: isSelected(),
        onSelected: (selected) => onSelected(selected),
        selectedColor: appBackgroundColor,
        disabledColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: appBackgroundColor)));
  }

  Widget _getCategoryInputWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getChoiceChip("нет", () => _category == UserCategories.none,
                  (selected) {
                setState(() {
                  _category = UserCategories.none;
                });
              }),
              getChoiceChip(
                  "учёный", () => _category == UserCategories.scientist,
                  (selected) {
                setState(() {
                  _category = UserCategories.scientist;
                });
              }),
              getChoiceChip(
                  "студент", () => _category == UserCategories.student,
                  (bool selected) {
                setState(() {
                  _category = UserCategories.student;
                });
              }),
              getChoiceChip("рабочий", () => _category == UserCategories.worker,
                  (bool selected) {
                setState(() {
                  _category = UserCategories.worker;
                });
              }),
              getChoiceChip(
                  "учитель", () => _category == UserCategories.teacher,
                  (bool selected) {
                setState(() {
                  _category = UserCategories.teacher;
                });
              }),
              getChoiceChip("школьник", () => _category == UserCategories.pupil,
                  (bool selected) {
                setState(() {
                  _category = UserCategories.pupil;
                });
              }),
              getChoiceChip(
                  "пенсионер", () => _category == UserCategories.pensioner,
                  (bool selected) {
                setState(() {
                  _category = UserCategories.pensioner;
                });
              }),
            ],
          ),
          _getFormByCategory(context, _category),
        ],
      ),
    );
  }

  void _userReady() {
    setState(() {
      if (_lastName == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указана фамилия читателя";
        return;
      }
      if (_firstName == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указано имя читателя";
        return;
      }
      if (_librarianId == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указано id библиотекаря";
        return;
      }
      UserCategoryInfo? categoryInfo;
      try {
        categoryInfo = _getCategoryInfo();
      } catch (e) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не верно указаны данные для категории";
        return;
      }
      ShortUserCategory? category;
      if (categoryInfo != null) {
        category = ShortUserCategory(categoryInfo.getCategoryName());
      }
      var user = User(
          -1, _lastName!, _firstName!, _patronymic, category, categoryInfo);

      _success = _userRepository.create(user, int.parse(_librarianId!));
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Добавление читателя",
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
                Text("Фамилия читателя",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _lastName = value;
                  },
                ),
                Text("Имя читателя",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _firstName = value;
                  },
                ),
                Text("Отчество читателя",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _patronymic = value;
                  },
                ),
                Text("id библиотекаря",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _librarianId = value;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Выбор категории",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                _getCategoryInputWidget(context),
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
                        child: Text("Читатель добавлен",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      FilledButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, "/users"),
                          child: const Text("Меню читателей")),
                    ]),
                  );
                }

                if (!snapshot.data!) {
                  return const Center(
                      child: Text(
                    "Ошибка: что-то пошло не так",
                    style: errorStyle,
                  ));
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Ошибка: ${snapshot.error?.toString()}",
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

class UsersAllScreen extends StatefulWidget {
  final bool isOverdue;
  const UsersAllScreen({super.key, required this.isOverdue});

  @override
  State<UsersAllScreen> createState() => _UsersAllScreenState(isOverdue);
}

class _UsersAllScreenState extends State<UsersAllScreen> {
  final bool isOverdue;
  final _userRepository = UserRepository();

  _UsersAllScreenState(this.isOverdue);

  late Future<List<User>> _users;

  @override
  void initState() {
    if (isOverdue) {
      _users = _userRepository.getOverdue();
    } else {
      _users = _userRepository.getAll();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title;
    if (isOverdue) {
      title = "Читатели с просроченным сроком литературы";
    } else {
      title = "Все читатели";
    }
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
    return Text("встречается в: ${_book!.name} (id книги: ${_book!.bookId})",
        style: Theme.of(context).textTheme.bodyLarge);
  }

  Widget _showCategoryNameIfCategory(BuildContext context) {
    if (_user.category == null) {
      return const Text("");
    }
    String title = "";
    switch (_user.categoryInfo!.getCategory()) {
      case (UserCategories.scientist):
        title = "учёный";
      case (UserCategories.student):
        title = "студент";
      case (UserCategories.worker):
        title = "рабочий";
      case (UserCategories.teacher):
        title = "учитель";
      case (UserCategories.pupil):
        title = "школьник";
      case (UserCategories.pensioner):
        title = "пенсионер";
      case (UserCategories.none):
        "";
    }
    if (title == "") {
      return const Text("");
    }
    return Text("Категория: $title",
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
              _showCategoryNameIfCategory(context),
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

class UsersByTemplate extends StatefulWidget {
  final bool isLwTmp;
  const UsersByTemplate({super.key, required this.isLwTmp});

  @override
  State<UsersByTemplate> createState() =>
      _UsersByTemplateState(isLwTmp: isLwTmp);
}

class _UsersByTemplateState extends State<UsersByTemplate> {
  final bool isLwTmp;
  final _userRepository = UserRepository();
  late Future<List<User>> _users;
  var _state = RequestWithParamsState.askingUser;
  String? _template;
  late String _errorMessage;

  _UsersByTemplateState({required this.isLwTmp});

  void _onTmpChanged(dynamic value) {
    _template = value;
  }

  void _userReady() {
    setState(() {
      if (_template == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Шаблон не введён";
        return;
      }

      _users = _userRepository.getByTmp(isLwTmp, _template!);
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    String paramName;
    if (isLwTmp) {
      title =
          "Перечень читателей, на руках у которых находится указанное произведение";
      paramName = "Название произведения";
    } else {
      title =
          "Список читателей, на руках у которых находится указанное издание";
      paramName = "Название издания (книги)";
    }
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
        body: switch (_state) {
          RequestWithParamsState.askingUser => ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              children: [
                Text(paramName, style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) => _onTmpChanged(value),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                        onPressed: _userReady,
                        child: const Row(
                          children: [Icon(Icons.search), Text("Искать")],
                        ))),
              ],
            ),
          RequestWithParamsState.showingInfo => FutureBuilder<List<User>>(
              future: _users,
              builder: (context, snapshot) {
                var isReady = snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done;

                if (isReady) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
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
              }),
          RequestWithParamsState.errorInput => Center(
              child: Text(_errorMessage, style: errorStyle),
            )
        });
  }
}

class UsersByLwAndPeriod extends StatefulWidget {
  const UsersByLwAndPeriod({super.key});

  @override
  State<UsersByLwAndPeriod> createState() => _UsersByLwAndPeriodState();
}

class _UsersByLwAndPeriodState extends State<UsersByLwAndPeriod> {
  final _userRepository = UserRepository();
  var _state = RequestWithParamsState.askingUser;
  late Future<List<Map<String, dynamic>>> _users;
  String? _lwtmp;
  late String _errorMessage;
  var _selectedDateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  void _onLwTmpChanged(dynamic value) {
    _lwtmp = value;
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
      if (_lwtmp == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Название произведения не введено";
        return;
      }

      _users = _userRepository.getByLWTmp(_lwtmp!, startDate, endDate);
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Перечень читателей, которые в течение указанного промежутка времени получали издание с некоторым произведением, и название этого издания",
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
                Text("Название произведения",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) => _onLwTmpChanged(value),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                      onPressed: () async {
                        final DateTimeRange? dateTimeRange =
                            await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (dateTimeRange != null) {
                          _selectedDateTimeRange = dateTimeRange;
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.calendar_today),
                        Text("Задать период")
                      ]),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                        onPressed: _userReady,
                        child: const Row(
                          children: [Icon(Icons.search), Text("Искать")],
                        ))),
              ],
            ),
          RequestWithParamsState.showingInfo =>
            FutureBuilder<List<Map<String, dynamic>>>(
                future: _users,
                builder: (context, snapshot) {
                  var isReady = snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done;

                  if (isReady) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      children: snapshot.data!
                          .map((e) => SingleUserInfo(
                                user: e["user"],
                                book: e["book"],
                              ))
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

class UsersByLibrarian extends StatefulWidget {
  const UsersByLibrarian({super.key});

  @override
  State<UsersByLibrarian> createState() => _UsersByLibrarianState();
}

class _UsersByLibrarianState extends State<UsersByLibrarian> {
  final _userRepository = UserRepository();
  var _state = RequestWithParamsState.askingUser;
  late Future<List<User>> _users;
  String? _librnLastName;
  late String _errorMessage;
  var _selectedDateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  void _onLwTmpChanged(dynamic value) {
    _librnLastName = value;
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
      if (_librnLastName == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Фамилия библиотекаря не введена";
        return;
      }

      _users = _userRepository.getByLibrn(_librnLastName!, startDate, endDate);
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Список читателей, которые в течение обозначенного периода были обслужены указанным библиотекарем",
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
                Text("Фамилия библиотекаря",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) => _onLwTmpChanged(value),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                      onPressed: () async {
                        final DateTimeRange? dateTimeRange =
                            await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (dateTimeRange != null) {
                          _selectedDateTimeRange = dateTimeRange;
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.calendar_today),
                        Text("Задать период")
                      ]),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                        onPressed: _userReady,
                        child: const Row(
                          children: [Icon(Icons.search), Text("Искать")],
                        ))),
              ],
            ),
          RequestWithParamsState.showingInfo => FutureBuilder<List<User>>(
              future: _users,
              builder: (context, snapshot) {
                var isReady = snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done;

                if (isReady) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
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
              }),
          RequestWithParamsState.errorInput => Center(
              child: Text(_errorMessage, style: errorStyle),
            )
        });
  }
}

class UsersNotVisitScreen extends StatefulWidget {
  const UsersNotVisitScreen({super.key});

  @override
  State<UsersNotVisitScreen> createState() => _UsersNotVisitScreenState();
}

class _UsersNotVisitScreenState extends State<UsersNotVisitScreen> {
  final _userRepository = UserRepository();
  var _state = RequestWithParamsState.askingUser;
  late Future<List<User>> _users;
  late String _errorMessage;
  var _selectedDateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  void _userReady() {
    setState(() {
      var startDate = _selectedDateTimeRange.start;
      var endDate = _selectedDateTimeRange.end;
      if (startDate.isAfter(endDate)) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Начало периода должно быть раньше конца периода";
        return;
      }

      _users = _userRepository.getNotVisit(startDate, endDate);
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Список читателей, не посещавших библиотеку в течение указанного времени",
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
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                      onPressed: () async {
                        final DateTimeRange? dateTimeRange =
                            await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (dateTimeRange != null) {
                          _selectedDateTimeRange = dateTimeRange;
                        }
                      },
                      child: const Row(children: [
                        Icon(Icons.calendar_today),
                        Text("Задать период")
                      ]),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: FilledButton(
                        onPressed: _userReady,
                        child: const Row(
                          children: [Icon(Icons.search), Text("Искать")],
                        ))),
              ],
            ),
          RequestWithParamsState.showingInfo => FutureBuilder<List<User>>(
              future: _users,
              builder: (context, snapshot) {
                var isReady = snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done;

                if (isReady) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
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
              }),
          RequestWithParamsState.errorInput => Center(
              child: Text(_errorMessage, style: errorStyle),
            )
        });
  }
}
