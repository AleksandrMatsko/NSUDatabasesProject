import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../utils/constants.dart';
import 'dtos.dart';

class LibrarianRepository {
  final _baseUrl = "http://$host:$port/api/librns";

  final _dio = Dio();

  Future<List<Librarian>> getAll() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((element) => Librarian.fromJson(element)).toList();
  }

  Future<List<Librarian>> getByPlace(String libName, int hallId) async {
    final response = await _dio.get(_baseUrl,
        options: Options(headers: {
          "Accept": "application/json",
        }),
        queryParameters: {
          "lib_name": libName,
          "hall": hallId,
        });
    final data = response.data as List;
    return data.map((element) => Librarian.fromJson(element)).toList();
  }

  Future<List<Map<String, dynamic>>> getReport(
      DateTime startDate, DateTime endDate) async {
    initializeDateFormatting();
    DateFormat formatter = DateFormat(dateTemplate);
    String start = formatter.format(startDate);
    String end = formatter.format(endDate);
    final response = await _dio.get("$_baseUrl/report",
        options: Options(headers: {
          "Accept": "application/json",
        }),
        queryParameters: {"start": start, "end": end});
    final data = response.data as List;
    return data.map((element) {
      var elementMap = element as Map<String, dynamic>;
      return {
        "librn": Librarian.fromJson(elementMap["librn"]),
        "numUsers": elementMap["numUsers"] as int,
      };
    }).toList();
  }
}
