import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:patrika_community_app/utils/helpers/exception_handler.dart';
import 'package:patrika_community_app/utils/values/app_urls.dart';

class NetworkRequester {
  factory NetworkRequester() {
    return shared;
  }

  NetworkRequester._privateConstructor() {
    prepareRequest();
  }
  late Dio _dio;

  static final NetworkRequester shared = NetworkRequester._privateConstructor();

  void prepareRequest() {
    final dioOptions = BaseOptions(
      baseUrl: AppUrls.prodBackendUrl,
      contentType: Headers.formUrlEncodedContentType,
      validateStatus: (status) {
        return status! < 500;
      },
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: _logNetwork,
      ),
    ]);
  }

  void _logNetwork(Object object) {
    if (object is RequestOptions) {
      log('REQUEST[${object.method}] => PATH: ${object.path}');
      log('REQUEST HEADERS: ${object.headers}');
      log('REQUEST DATA: ${object.data}');
    } else if (object is Response) {
      log('RESPONSE[${object.statusCode}] => PATH: '
          '${object.requestOptions.path}');
      log('RESPONSE HEADERS: ${object.headers}');
      log('RESPONSE DATA: ${object.data}');
    } else if (object is DioException) {
      log('DIO ERROR[${object.response?.statusCode}]: ${object.message}');
      log('ERROR STACK TRACE: ${object.stackTrace}');
    } else {
      log(object.toString());
    }
  }

  Future<Response<dynamic>> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      log('Starting GET request to $path');
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      log('GET request to $path completed successfully');
      return response;
    } on Exception catch (exception) {
      log('Error in GET request to $path: $exception');
      throw ExceptionHandler.handleError(exception);
    }
  }

  Future<Response<dynamic>> post({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      log('Starting POST request to $path');
      final response = await _dio.post<dynamic>(
        path,
        queryParameters: queryParameters,
        data: body,
        options: Options(headers: headers),
      );
      log('POST request to $path completed successfully');
      return response;
    } on Exception catch (exception) {
      log('Error in POST request to $path: $exception');
      throw ExceptionHandler.handleError(exception);
    }
  }
}
