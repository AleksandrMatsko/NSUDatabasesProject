import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'menu.dart';
import 'repositories/literary_work_repository.dart';
import 'repositories/dtos.dart';
import 'utils/constants.dart';

class LWOptionsScreen extends StatelessWidget {
  const LWOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Литературные произведения",
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
                onPressed: () => Navigator.pushNamed(context, "/lws/getAll"),
                child: const Text("Получить все литературные произведения")),
            OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, "/lws/popular"),
                child: const Text(
                    "Получить популярные литературные произведения")),
            OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, "/lws/addOne"),
                child: const Text("Добавить новое литературное произведение")),
          ],
        ));
  }
}

class LWCreateScreen extends StatefulWidget {
  const LWCreateScreen({super.key});

  @override
  State<LWCreateScreen> createState() => _LWCreateScreenState();
}

class _LWCreateScreenState extends State<LWCreateScreen> {
  final _lwRepository = LWRepository();
  late Future<bool> _success;
  var _state = RequestWithParamsState.askingUser;
  late String _errorMessage;
  String? _name;
  String? _authorIdsOneLine;

  var _category = LWCategories.none;
  Map<String, dynamic> _formParams = {};

  LWCategoryInfo? _getCategoryInfo() {
    if (_formParams.isEmpty) {
      return null;
    }
    switch (_category) {
      case (LWCategories.novel):
        {
          var strNum = _formParams.remove("numberChapters");
          _formParams["numberChapters"] = int.parse(strNum!);
          return Novel.fromJson(_formParams);
        }
      case (LWCategories.scientificArticle):
        {
          return ScientificArticle.fromJson(_formParams);
        }
      case (LWCategories.textbook):
        {
          return Textbook.fromJson(_formParams);
        }
      case (LWCategories.poem):
        {
          return Poem.fromJson(_formParams);
        }
      default:
        {
          return null;
        }
    }
  }

  Widget _getFormByCategory(BuildContext context, LWCategories category) {
    switch (category) {
      case (LWCategories.scientificArticle):
        {
          initializeDateFormatting();
          DateFormat formatter = DateFormat(dateTemplate);
          _formParams = {
            "dateIssue": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: FilledButton(
                    onPressed: () async {
                      final DateTime? dateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      );
                      if (dateTime != null) {
                        _formParams["dateIssue"] = formatter.format(dateTime);
                      }
                    },
                    child: const Row(children: [
                      Icon(Icons.calendar_today),
                      Text("Задать дату получения")
                    ]),
                  )),
            ],
          );
        }
      case (LWCategories.novel):
        {
          _formParams = {
            "numberChapters": null,
            "shortDesc": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Количество глав",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["numberChapters"] = value;
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              Text(
                "Краткое описание",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["shortDesc"] = value;
                },
              ),
            ],
          );
        }
      case (LWCategories.textbook):
        {
          _formParams = {
            "subject": null,
            "complexityLevel": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Предмет",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["subject"] = value;
                },
              ),
              Text(
                "Уровень сложности",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["complexityLevel"] = value;
                },
              ),
            ],
          );
        }
      case (LWCategories.poem):
        {
          _formParams = {
            "rhymingMethod": null,
            "verseSize": null,
          };
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Способ рифмовки",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["rhymingMethod"] = value;
                },
              ),
              Text(
                "Стихотворный размер",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                showCursor: true,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  _formParams["verseSize"] = value;
                },
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
              getChoiceChip("нет", () => _category == LWCategories.none,
                  (selected) {
                setState(() {
                  _category = LWCategories.none;
                });
              }),
              getChoiceChip("роман", () => _category == LWCategories.novel,
                  (selected) {
                setState(() {
                  _category = LWCategories.novel;
                });
              }),
              getChoiceChip("научная статья",
                  () => _category == LWCategories.scientificArticle,
                  (bool selected) {
                setState(() {
                  _category = LWCategories.scientificArticle;
                });
              }),
              getChoiceChip("учебник", () => _category == LWCategories.textbook,
                  (bool selected) {
                setState(() {
                  _category = LWCategories.textbook;
                });
              }),
              getChoiceChip("поэма", () => _category == LWCategories.poem,
                  (bool selected) {
                setState(() {
                  _category = LWCategories.poem;
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
      if (_name == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указано название литературного произведения";
        return;
      }
      if (_authorIdsOneLine == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указан автор или авторы произведения";
        return;
      }

      _authorIdsOneLine =
          _authorIdsOneLine!.replaceAll(RegExp(r"[^0-9\s]"), "");
      List<String> stringAuthorIds = _authorIdsOneLine!.split(" ");
      List<int> authorIds = stringAuthorIds.map((e) => int.parse(e)).toList();

      LWCategoryInfo? categoryInfo;
      try {
        categoryInfo = _getCategoryInfo();
      } catch (e) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не верно указаны данные для категории";
        return;
      }
      LWCategory? category;
      if (categoryInfo != null) {
        category = LWCategory(-1, categoryInfo.getCategoryName());
      }
      var lw = LiteraryWork(-1, _name!, category, categoryInfo, []);

      _success = _lwRepository.create(lw, authorIds);
      _state = RequestWithParamsState.showingInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Добавление литературного произведения",
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
                Text("Название литературного произведения",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                Text("id авторов (числа через пробел)",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextFormField(
                  showCursor: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    _authorIdsOneLine = value;
                  },
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
                        child: Text("Литературное произведение добавлено",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      FilledButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, "/lws"),
                          child: const Text("Меню произведений")),
                    ]),
                  );
                }

                if (isReady && !snapshot.data!) {
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

class LWAllScreen extends StatefulWidget {
  const LWAllScreen({super.key});

  @override
  State<LWAllScreen> createState() => _LWAllScreenState();
}

class _LWAllScreenState extends State<LWAllScreen> {
  final _lwRepository = LWRepository();
  late Future<List<LiteraryWork>> _lws;

  @override
  void initState() {
    super.initState();
    _lws = _lwRepository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Все литературные произведения",
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
      body: FutureBuilder<List<LiteraryWork>>(
        future: _lws,
        builder: (context, snapshot) {
          var isReady = snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done;

          if (isReady) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: snapshot.data!
                  .map((lw) => SingleLWInfo(
                        lw: lw,
                        count: null,
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

class SingleLWInfo extends StatelessWidget {
  final LiteraryWork _lw;
  final _lwRepository = LWRepository();
  final int? count;
  SingleLWInfo({super.key, required lw, required this.count}) : _lw = lw;

  Widget _showIfCount(BuildContext context) {
    if (count == null) {
      return const Text("");
    }
    return Text("брали раз: $count",
        style: Theme.of(context).textTheme.bodyLarge);
  }

  Widget _showIfCategory(BuildContext context) {
    if (_lw.category == null) {
      return const Text("");
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(15.0),
          width: 800,
          child: Column(
            children: _lw.categoryInfo!
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
                        "id: ${_lw.lwId}   ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(_lw.name,
                          style: Theme.of(context).textTheme.headlineMedium),
                      Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: _showIfCount(context)),
                    ],
                  )),
              Text("Авторы:", style: Theme.of(context).textTheme.bodyLarge),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15.0),
                    width: 800,
                    child: Column(
                      children: _lw.authors
                          .map((a) => Row(
                                children: [
                                  Text("authorId: ${a.authorId}   ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(
                                    "${a.lastName} ${a.firstName} ${a.patronymic ?? ""}",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ))
                          .toList(),
                    )),
              ),
              _showIfCategory(context),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                    onPressed: () {
                      _lwRepository.deleteById(_lw.lwId);
                      Navigator.pushReplacementNamed(context, "/lws");
                    },
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

class PopularLWScreen extends StatefulWidget {
  const PopularLWScreen({super.key});

  @override
  State<PopularLWScreen> createState() => _PopularLWScreenState();
}

class _PopularLWScreenState extends State<PopularLWScreen> {
  var _state = RequestWithParamsState.askingUser;
  final _lwRepository = LWRepository();
  late Future<List<Map<String, dynamic>>> _lws;
  String? _limit;
  late String _errorMessage;

  void _userReady() {
    setState(() {
      if (_limit == null) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не указано количество";
        return;
      }
      var limit = int.parse(_limit!);
      if (limit <= 0) {
        _state = RequestWithParamsState.errorInput;
        _errorMessage = "Не верно указано количество";
        return;
      }
      _state = RequestWithParamsState.showingInfo;
      _lws = _lwRepository.getPopular(limit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Популярные литературные произведения",
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
          RequestWithParamsState.showingInfo =>
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _lws,
              builder: (context, snapshot) {
                var isReady = snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done;

                if (isReady) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    children: snapshot.data!
                        .map((e) =>
                            SingleLWInfo(lw: e["lw"], count: e["count"] as int))
                        .toList(),
                  );
                }

                if (snapshot.hasError) {
                  return Text("Ошибка: ${snapshot.error?.toString()}");
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          RequestWithParamsState.askingUser => ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                children: [
                  Text(
                    "Количество",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextFormField(
                    showCursor: true,
                    style: Theme.of(context).textTheme.bodyLarge,
                    onChanged: (value) {
                      _limit = value;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: FilledButton(
                          onPressed: _userReady,
                          child: const Row(
                            children: [Icon(Icons.search), Text("Искать")],
                          ))),
                ]),
          RequestWithParamsState.errorInput => Center(
              child: Text(_errorMessage, style: errorStyle),
            ),
        });
  }
}
