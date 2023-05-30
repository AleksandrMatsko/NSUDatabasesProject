import 'package:flutter/material.dart';

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

  Future<bool> create(ShortAuthor author) async {
    final response = await _dio.post(
      _baseUrl,
      data: author.toJsonCreate(),
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

  Future<Map<String, dynamic>?> deleteById(int id) async {
    final response = await _dio.delete(_baseUrl,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
        queryParameters: {"id": id});
    return response.data;
  }
}
