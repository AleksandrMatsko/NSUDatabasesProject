import '../utils/constants.dart';
import 'package:dio/dio.dart';
import 'dtos.dart';

class AuthorRepository {
  final _baseUrl = "http://$host:$port/api/authors";

  final _dio = Dio();

  Future<List<Author>> getAllAuthors() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((element) => Author.fromJson(element)).toList();
  }
}
