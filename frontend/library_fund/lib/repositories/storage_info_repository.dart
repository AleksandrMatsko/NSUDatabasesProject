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
}
