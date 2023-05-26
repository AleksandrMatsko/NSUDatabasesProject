class ShortLW {
  int lwId;
  String name;

  ShortLW(this.lwId, this.name);

  factory ShortLW.fromJson(dynamic json) {
    return ShortLW(json["lwId"] as int, json["name"] as String);
  }
}

class LWCategory {
  int categoryId;
  String categoryName;

  LWCategory(this.categoryId, this.categoryName);

  factory LWCategory.fromJson(dynamic json) {
    return LWCategory(
        json["categoryId"] as int, json["categoryName"] as String);
  }
}

enum LWCategories { novel, scientificArticle, textbook, poem }

abstract class LWCategoryInfo {
  LWCategoryInfo();
  LWCategoryInfo.fromJson(dynamic json);

  Map<String, dynamic> getTranslated();
  LWCategories getCategory();
}

class Novel extends LWCategoryInfo {
  final LWCategories category = LWCategories.novel;
  late int numberChapters;
  late String? shortDesc;

  Novel() : super();

  factory Novel.fromJson(dynamic json) {
    var novel = Novel();
    novel.numberChapters = json["numberChapters"];
    novel.shortDesc = json["shortDesc"];
    return novel;
  }

  @override
  Map<String, dynamic> getTranslated() {
    return {"количество глав": numberChapters, "краткое описание": shortDesc};
  }

  @override
  LWCategories getCategory() {
    return category;
  }
}

class ScientificArticle extends LWCategoryInfo {
  final LWCategories category = LWCategories.scientificArticle;
  late String dateIssue;

  ScientificArticle() : super();

  factory ScientificArticle.fromJson(dynamic json) {
    var article = ScientificArticle();
    article.dateIssue = json["dateIssue"];
    return article;
  }

  @override
  Map<String, dynamic> getTranslated() {
    return {"дата выхода": dateIssue};
  }

  @override
  LWCategories getCategory() {
    return category;
  }
}

class Textbook extends LWCategoryInfo {
  final LWCategories category = LWCategories.textbook;
  late String subject;
  late String complexityLevel;

  Textbook() : super();

  factory Textbook.fromJson(dynamic json) {
    var textbook = Textbook();
    textbook.subject = json["subject"];
    textbook.complexityLevel = json["complexityLevel"];
    return textbook;
  }

  @override
  Map<String, dynamic> getTranslated() {
    return {"предмет": subject, "уровень сложности": complexityLevel};
  }

  @override
  LWCategories getCategory() {
    return category;
  }
}

class Poem extends LWCategoryInfo {
  final LWCategories category = LWCategories.poem;
  late String verseSize;
  late String rhymingMethod;

  Poem() : super();

  factory Poem.fromJson(dynamic json) {
    var poem = Poem();
    poem.verseSize = json["verseSize"];
    poem.rhymingMethod = json["rhymingMethod"];
    return poem;
  }

  @override
  Map<String, dynamic> getTranslated() {
    return {"размер стиха": verseSize, "способ рифмовки": rhymingMethod};
  }

  @override
  LWCategories getCategory() {
    return category;
  }
}

class LiteraryWork {
  int lwId;
  String name;
  LWCategory? category;
  LWCategoryInfo? categoryInfo;
  List<ShortAuthor> authors;

  LiteraryWork(
      this.lwId, this.name, this.category, this.categoryInfo, this.authors);

  factory LiteraryWork.fromJson(dynamic json) {
    LWCategory? lwCategory;
    LWCategoryInfo? lwCategoryInfo;
    var lwCategoryData = json["category"];
    var lwCategoryInfoData = json["categoryInfo"];
    if (lwCategoryData != null) {
      lwCategory = LWCategory.fromJson(lwCategoryData);
      if (lwCategoryInfoData != null) {
        switch (lwCategory.categoryName) {
          case ("novel"):
            lwCategoryInfo = Novel.fromJson(lwCategoryInfoData);
          case ("poem"):
            lwCategoryInfo = Poem.fromJson(lwCategoryInfoData);
          case ("scientific article"):
            lwCategoryInfo = ScientificArticle.fromJson(lwCategoryInfoData);
          case ("textbook"):
            lwCategoryInfo = Textbook.fromJson(lwCategoryInfoData);
          default:
            {
              lwCategory = null;
            }
        }
      }
    }
    var authorObj = json["authors"] as List;
    return LiteraryWork(json["lwId"] as int, json["name"] as String, lwCategory,
        lwCategoryInfo, authorObj.map((e) => ShortAuthor.fromJson(e)).toList());
  }
}

class ShortAuthor {
  int authorId;
  String lastName;
  String firstName;
  String? patronymic;

  ShortAuthor(this.authorId, this.lastName, this.firstName, this.patronymic);

  factory ShortAuthor.fromJson(dynamic json) {
    return ShortAuthor(json["authorId"] as int, json["lastName"] as String,
        json["firstName"] as String, json["patronymic"] as String?);
  }
}

class Author {
  int authorId;
  String lastName;
  String firstName;
  String? patronymic;
  List<ShortLW> literaryWorks;

  Author(this.authorId, this.lastName, this.firstName, this.patronymic,
      this.literaryWorks);

  factory Author.fromJson(dynamic json) {
    var lwObjectsJson = json["literaryWorks"] as List;
    return Author(
        json["authorId"] as int,
        json["lastName"] as String,
        json["firstName"] as String,
        json["patronymic"] as String?,
        lwObjectsJson.map((obj) => ShortLW.fromJson(obj)).toList());
  }
}

class Book {
  int bookId;
  String name;
  List<ShortLW> literaryWorks;

  Book(this.bookId, this.name, this.literaryWorks);

  factory Book.fromJson(dynamic json) {
    var lwObjectsJson = json["literaryWorks"] as List;
    return Book(json["bookId"] as int, json["name"] as String,
        lwObjectsJson.map((obj) => ShortLW.fromJson(obj)).toList());
  }
}

class ShortUserCategory {
  String categoryName;

  ShortUserCategory(this.categoryName);

  factory ShortUserCategory.fromJson(dynamic json) {
    return ShortUserCategory(json["categoryName"] as String);
  }
}

class ShortUser {
  int userId;
  String lastName;
  String firstName;
  String? patronymic;
  ShortUserCategory? category;

  ShortUser(this.userId, this.lastName, this.firstName, this.patronymic,
      this.category);

  factory ShortUser.fromJson(dynamic json) {
    ShortUserCategory? category;
    if (json["category"] != null) {
      category = ShortUserCategory.fromJson(json["category"]);
    }
    return ShortUser(json["userId"] as int, json["lastName"] as String,
        json["firstName"] as String, json["patronymic"] as String?, category);
  }
}

class ShortLibrarian {
  int librarianId;
  String lastName;
  String firstName;
  String? patronymic;

  ShortLibrarian(
      this.librarianId, this.lastName, this.firstName, this.patronymic);

  factory ShortLibrarian.fromJson(dynamic json) {
    return ShortLibrarian(
        json["librarianId"] as int,
        json["lastName"] as String,
        json["firstName"] as String,
        json["patronymic"] as String?);
  }
}

class LibHall {
  int hallId;
  List<ShortLibrarian> librarians;

  LibHall(this.hallId, this.librarians);

  factory LibHall.fromJson(dynamic json) {
    var librarianObjs = json["librarians"] as List;
    return LibHall(json["hallId"],
        librarianObjs.map((e) => ShortLibrarian.fromJson(e)).toList());
  }
}

class Library {
  int libraryId;
  String name;
  String district;
  String street;
  String building;
  List<LibHall> halls;

  Library(this.libraryId, this.name, this.district, this.street, this.building,
      this.halls);

  factory Library.fromJson(dynamic json) {
    var hallObj = json["halls"] as List;
    return Library(
        json["libraryId"],
        json["name"],
        json["district"],
        json["street"],
        json["building"],
        hallObj.map((e) => LibHall.fromJson(e)).toList());
  }
}

class ShortLibrary {
  int libraryId;
  String name;

  ShortLibrary(this.libraryId, this.name);

  factory ShortLibrary.fromJson(dynamic json) {
    return ShortLibrary(json["libraryId"] as int, json["name"] as String);
  }
}

class RegistrationJournal {
  String registrationDate;
  ShortUser user;
  ShortLibrarian librarian;
  ShortLibrary library;

  RegistrationJournal(
      this.registrationDate, this.user, this.librarian, this.library);

  factory RegistrationJournal.fromJson(dynamic json) {
    return RegistrationJournal(
        json["registrationDate"] as String,
        ShortUser.fromJson(json["user"]),
        ShortLibrarian.fromJson(json["librarian"]),
        ShortLibrary.fromJson(json["library"]));
  }
}

class ShortStorageInfo {
  int storedId;
  int durationIssue;

  ShortStorageInfo(this.storedId, this.durationIssue);

  factory ShortStorageInfo.fromJson(dynamic json) {
    return ShortStorageInfo(
        json["storedId"] as int, json["durationIssue"] as int);
  }
}

class IssueJournal {
  int issueId;
  ShortStorageInfo stored;
  String dateIssue;
  String? dateReturn;
  ShortUser user;
  ShortLibrarian issuedBy;
  ShortLibrarian? acceptedBy;

  IssueJournal(this.issueId, this.stored, this.dateIssue, this.dateReturn,
      this.user, this.issuedBy, this.acceptedBy);

  factory IssueJournal.fromJson(dynamic json) {
    ShortLibrarian? librn;
    if (json["acceptedBy"] != null) {
      librn = ShortLibrarian.fromJson(json["acceptedBy"]);
    }
    return IssueJournal(
        json["issueId"] as int,
        ShortStorageInfo.fromJson(json["stored"]),
        json["dateIssue"] as String,
        json["dateReturn"] as String?,
        ShortUser.fromJson(json["user"]),
        ShortLibrarian.fromJson(json["issuedBy"]),
        librn);
  }
}
