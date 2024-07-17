import 'package:dio/dio.dart';
import '/services/logging_service.dart';
import '/utils/helpers/exception_handler.dart';
import '/utils/values/app_urls.dart';

class NetworkRequester {
  late Dio _dio;
  late LoggingService _log;

  NetworkRequester._privateConstructor() {
    _log = LoggingService();
    prepareRequest();
  }

  static final NetworkRequester shared = NetworkRequester._privateConstructor();

  factory NetworkRequester({LoggingService? log}) {
    if (log != null) {
      shared._log = log;
    }
    return shared;
  }

  void prepareRequest() {
    BaseOptions dioOptions = BaseOptions(
      baseUrl: AppUrls.prodBackendUrl,
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    _dio.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        logPrint: _logNetwork,
      )
    ]);
  }

  void _logNetwork(Object object) {
    if (object is RequestOptions) {
      _log.info('REQUEST[${object.method}] => PATH: ${object.path}');
      _log.debug('REQUEST HEADERS: ${object.headers}');
      _log.debug('REQUEST DATA: ${object.data}');
    } else if (object is Response) {
      _log.info(
          'RESPONSE[${object.statusCode}] => PATH: ${object.requestOptions.path}');
      _log.debug('RESPONSE HEADERS: ${object.headers}');
      _log.debug('RESPONSE DATA: ${object.data}');
    } else if (object is DioException) {
      _log.error(
          'DIO ERROR[${object.response?.statusCode}]: ${object.message}');
      _log.error('ERROR STACK TRACE: ${object.stackTrace}');
    } else {
      _log.debug(object.toString());
    }
  }

  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      _log.info('Starting GET request to $path');
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      _log.info('GET request to $path completed successfully');
      return response.data;
    } on Exception catch (exception) {
      _log.error('Error in GET request to $path: ${exception.toString()}');
      return ExceptionHandler.handleError(exception);
    }
  }

  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      _log.info('Starting POST request to $path');
      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: body,
        options: Options(headers: headers),
      );
      _log.info('POST request to $path completed successfully');
      return response.data;
    } on Exception catch (exception) {
      _log.error('Error in POST request to $path: ${exception.toString()}');
      return ExceptionHandler.handleError(exception);
    }
  }
}
