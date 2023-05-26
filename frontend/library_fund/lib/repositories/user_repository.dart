import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../utils/constants.dart';
import 'dtos.dart';

class UserRepository {
  final _baseUrl = "http://$host:$port/api/users";

  final _dio = Dio();

  Future<List<User>> getAll() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((element) => User.fromJson(element)).toList();
  }

  Future<List<Map<String, dynamic>>> getByLWTmp(
      String lwTmp, DateTime startDate, DateTime endDate) async {
    initializeDateFormatting();
    DateFormat formatter = DateFormat(dateTemplate);
    String start = formatter.format(startDate);
    String end = formatter.format(endDate);
    final response = await _dio.get(_baseUrl,
        options: Options(headers: {
          "Accept": "application/json",
        }),
        queryParameters: {"lwtmp": lwTmp, "start": start, "end": end});
    final data = response.data as List;
    return data.map((element) {
      var elementMap = element as Map<String, dynamic>;
      return {
        "user": User.fromJson(elementMap["user"]),
        "book": ShortBook.fromJson(elementMap["book"]),
      };
    }).toList();
  }

  Future<List<User>> getByLibrn(
      String librnLastName, DateTime startDate, DateTime endDate) async {
    initializeDateFormatting();
    DateFormat formatter = DateFormat(dateTemplate);
    String start = formatter.format(startDate);
    String end = formatter.format(endDate);
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
      queryParameters: {
        "librn_last_name": librnLastName,
        "start": start,
        "end": end
      },
    );
    final data = response.data as List;
    return data.map((element) => User.fromJson(element)).toList();
  }

  Future<List<User>> getOverdue() async {
    final response = await _dio.get(
      "$_baseUrl/overdue",
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((element) => User.fromJson(element)).toList();
  }

  Future<List<User>> getNotVisit(DateTime startDate, DateTime endDate) async {
    initializeDateFormatting();
    DateFormat formatter = DateFormat(dateTemplate);
    String start = formatter.format(startDate);
    String end = formatter.format(endDate);
    final response = await _dio.get(
      "$_baseUrl/not_visit",
      options: Options(headers: {
        "Accept": "application/json",
      }),
      queryParameters: {"start": start, "end": end},
    );
    final data = response.data as List;
    return data.map((element) => User.fromJson(element)).toList();
  }
}
