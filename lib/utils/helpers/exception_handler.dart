// ignore_for_file: always_declare_return_types, type_annotate_public_apis, inference_failure_on_function_return_type

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:patrika_community_app/utils/helpers/error_message.dart';

class APIException implements Exception {
  APIException({required this.message});
  final String message;
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
        case DioExceptionType.cancel:
          return APIException(message: ErrorMessages.networkGeneral);
        case DioExceptionType.receiveTimeout:
          return APIException(message: ErrorMessages.networkGeneral);
        case DioExceptionType.sendTimeout:
          return APIException(message: ErrorMessages.networkGeneral);
        case DioExceptionType.badCertificate:
          return APIException(message: ErrorMessages.networkGeneral);
        case DioExceptionType.unknown:
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
    // TODOshow snackbar
  }
}
