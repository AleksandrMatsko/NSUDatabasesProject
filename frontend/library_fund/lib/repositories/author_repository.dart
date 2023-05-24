import '../utils/constants.dart';
import 'package:dio/dio.dart';

class AuthorRepository {
  final _baseUrl = "http://$host:$port/api/";

  final _dio = Dio();

  Future<List<Author>> getAuthorsList() async {
    var path = "authors";
    final response = await _dio.get(
      _baseUrl + path,
      options: Options(headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      }),
    );
    final data = response.data as List;
    return data.map((element) => Author.fromJson(element)).toList();
  }
}

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
