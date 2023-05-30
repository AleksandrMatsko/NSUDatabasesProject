import 'package:flutter/material.dart';

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

  Future<bool> create(LiteraryWork user, List<int> authorIds) async {
    var body = user.toJsonCreate();
    body.putIfAbsent("authors", () => authorIds);
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
