import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BaseUrl {
  static String uri =
      "https://tiktok-download-without-watermark.p.rapidapi.com/analysis";
}

class DioHelper {
  static final BaseOptions _options = BaseOptions(
    baseUrl: BaseUrl.uri,
    connectTimeout: 60 * 1000,
    receiveTimeout: 60 * 1000,
    followRedirects: false,
    validateStatus: (status) => true,
  );

  static final Dio _dio = Dio(_options);

  static Future getWithToken({
    required String endpoint,
  }) async {
    Map<String, String> headers = {
      'X-RapidAPI-Key': '******',
      'X-RapidAPI-Host':
          'tiktok-download-without-watermark.p.rapidapi.com'
    };
    try {
      Response response =
          await _dio.get(endpoint, options: Options(headers: headers));
      return response;
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
        if (e.type == DioErrorType.other) {
          throw Exception("Connection Timeout Exception");
        }
      }
    }
  }
}
