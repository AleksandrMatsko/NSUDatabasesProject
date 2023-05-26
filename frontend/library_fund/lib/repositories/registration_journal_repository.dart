import '../utils/constants.dart';
import 'package:dio/dio.dart';
import 'dtos.dart';

class RJRepository {
  final _baseUrl = "http://$host:$port/api/rj";

  final _dio = Dio();

  Future<List<RegistrationJournal>> getAll() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data
        .map((element) => RegistrationJournal.fromJson(element))
        .toList();
  }
}
