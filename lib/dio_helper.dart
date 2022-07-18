import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BaseUrl {
  static String uri =
      "https://tiktok-downloader-download-tiktok-videos-without-watermark.p.rapidapi.com/vid/index";
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
      'X-RapidAPI-Key': 'c78fb7752emshb95ef22f72fd769p1468a5jsnfd923c5b8b17',
      'X-RapidAPI-Host':
          'tiktok-downloader-download-tiktok-videos-without-watermark.p.rapidapi.com'
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
