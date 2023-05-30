import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'package:dio/dio.dart';
import 'dtos.dart';

class SIRepository {
  final _baseUrl = "http://$host:$port/api/si";

  final _dio = Dio();

  Future<List<StorageInfo>> getAll() async {
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
    );
    final data = response.data as List;
    return data.map((element) => StorageInfo.fromJson(element)).toList();
  }

  Future<List<StorageInfo>> getByTmp(bool isLwTmp, String tmp) async {
    Map<String, dynamic> queryParams = {};
    if (isLwTmp) {
      queryParams.putIfAbsent("lwtmp", () => tmp);
    } else {
      queryParams.putIfAbsent("author", () => tmp);
    }
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {
        "Accept": "application/json",
      }),
      queryParameters: queryParams,
    );
    final data = response.data as List;
    return data.map((element) => StorageInfo.fromJson(element)).toList();
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

  Future<Map<String, dynamic>?> deleteById(int id) async {
    final response = await _dio.delete(_baseUrl,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
        queryParameters: {"id": id});
    return response.data;
  }

  Future<dynamic> update(Map<String, dynamic> params) async {
    final response = await _dio.put("$_baseUrl/${params["storedId"]}",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
        data: params);
    return response.data;
  }
}
