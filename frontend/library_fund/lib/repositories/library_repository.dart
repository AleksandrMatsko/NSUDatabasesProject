import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'package:dio/dio.dart';
import 'dtos.dart';

class LibraryRepository {
  final _baseUrl = "http://$host:$port/api/libs";

  final _dio = Dio();

  Future<List<Library>> getAll() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((element) => Library.fromJson(element)).toList();
  }

  Future<bool> create(Map<String, dynamic> body) async {
    debugPrint(body.toString());
    final response = await _dio.post(
      _baseUrl,
      data: body,
      options: Options(headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      }),
    );
    if (response.statusCode != null && response.statusCode! ~/ 100 == 2) {
      debugPrint(response.data.toString());
      return true;
    }
    return false;
  }
}
