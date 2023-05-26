class ShortLW {
  int lwId;
  String name;

  ShortLW(this.lwId, this.name);

  factory ShortLW.fromJson(dynamic json) {
    return ShortLW(json["lwId"] as int, json["name"] as String);
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
