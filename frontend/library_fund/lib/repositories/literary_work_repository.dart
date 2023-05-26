import '../utils/constants.dart';
import 'package:dio/dio.dart';
import 'dtos.dart';

class LWRepository {
  final _baseUrl = "http://$host:$port/api/lws";

  final _dio = Dio();

  Future<List<LiteraryWork>> getAll() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((element) => LiteraryWork.fromJson(element)).toList();
  }

  Future<List<Map<String, dynamic>>> getPopular(int limit) async {
    final response = await _dio.get("$_baseUrl/popular",
        options: Options(headers: {
          "Accept": "application/json",
        }),
        queryParameters: {"limit": limit});
    final data = response.data as List;
    return data.map((element) {
      var elementMap = element as Map<String, dynamic>;
      return {
        "lw": LiteraryWork.fromJson(elementMap["lw"]),
        "count": elementMap["count"] as int,
      };
    }).toList();
  }
}
