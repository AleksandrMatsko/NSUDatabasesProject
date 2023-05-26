import '../utils/constants.dart';
import 'package:dio/dio.dart';
import 'dtos.dart';

class IJRepository {
  final _baseUrl = "http://$host:$port/api/ij";

  final _dio = Dio();

  Future<List<IssueJournal>> getAll() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((element) => IssueJournal.fromJson(element)).toList();
  }
}
