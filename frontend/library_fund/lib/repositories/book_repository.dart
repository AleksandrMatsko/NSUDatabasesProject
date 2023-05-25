import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../utils/constants.dart';
import 'dtos.dart';

class BookRepository {
  final _baseUrl = "http://$host:$port/api/books";

  final _dio = Dio();

  Future<List<Book>> getAllBooks() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((e) => Book.fromJson(e)).toList();
  }

  Future<List<Book>> getBooksFromLib(bool regLib, String userLastName,
      DateTime startDate, DateTime endDate) async {
    initializeDateFormatting();
    DateFormat formatter = DateFormat(dateTemplate);
    String start = formatter.format(startDate);
    String end = formatter.format(endDate);
    String url;
    if (regLib) {
      url = "$_baseUrl/from_reg_lib";
    } else {
      url = "$_baseUrl/not_from_reg_lib";
    }
    final response = await _dio.get(url,
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
        queryParameters: {
          "user_last_name": userLastName,
          "start": start,
          "end": end
        });
    final data = response.data as List;
    return data.map((e) => Book.fromJson(e)).toList();
  }
}
