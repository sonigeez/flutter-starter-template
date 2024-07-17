import 'dart:io';

import 'package:dio/dio.dart';
import '/utils/helpers/error_message.dart';

class APIException implements Exception {
  final String message;

  APIException({required this.message});
}

class ExceptionHandler {
  ExceptionHandler._privateConstructor();

  static APIException handleError(Exception error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return APIException(message: ErrorMessages.noInternet);
        case DioExceptionType.connectionError:
          return APIException(message: ErrorMessages.connectionTimeout);
        case DioExceptionType.badResponse:
          return APIException(message: ErrorMessages.networkGeneral);

        default:
          if (error.error is SocketException) {
            return APIException(
              message: ErrorMessages.networkGeneral,
            );
          }
          return APIException(message: ErrorMessages.networkGeneral);
      }
    } else {
      return APIException(message: ErrorMessages.networkGeneral);
    }
  }
}

class ErrorHandler {
  ErrorHandler._privateConstructor();

  static handleError(APIException? error) {
    displayError(error?.message ?? ErrorMessages.networkGeneral);
  }

  static displayError(String? error) {
    // todo show snackbar
  }
}
