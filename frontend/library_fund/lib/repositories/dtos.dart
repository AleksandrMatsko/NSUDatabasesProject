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
