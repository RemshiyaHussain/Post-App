import 'dart:developer';

import 'package:dio/dio.dart';

class ApiServices {
  ApiServices._();
  static final instance = ApiServices._();
  factory ApiServices() => instance;
  static Dio dio = Dio()
    ..options = BaseOptions(
        baseUrl: "https://node-backend-40ct.onrender.com/",
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60));

  static Future<Response> get(
      {required String path, Map<String, dynamic>? queryparameters}) async {
    try {
      final Response response = await dio.get(path,
          queryParameters: queryparameters,
          options: Options(headers: {"key": "oxdo"}));
          log(response.toString(),name: "get all response api service here");
      return response;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  static Future<Response> post(
      {required String path,
      Map<String, dynamic>? jsonData,
      FormData? formData}) async {
    log(path, name: "post request");
    try {
      final Response response = await dio.post(path,
          data: formData ?? jsonData,
          options: Options(headers: {
            Headers.contentTypeHeader: 'application/json',
            "key": "oxdo"
          }));
      log(response.toString(), name: "response in api service");
      return response;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }


  
  static Future<Response> put(
      String path, Map<String, dynamic> jsonData) async {
    try {
      final Response response = await dio.put(path,
          data: jsonData, options: Options(headers: {"key": "oxdo"}));
       
      return response;
    
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  static Future<Response> delete(String path) async {
    try {
      final Response response =
          await dio.delete(path, options: Options(headers: {"key": "oxdo"}));
      return response;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
  

}