import 'dart:io';
import 'package:desktop_app/model/model_api.dart';
import 'package:dio/dio.dart';

// ignore: constant_identifier_names
const String ErrorInternalTitle = 'error_internal_server';
// ignore: constant_identifier_names
const String ErrorApplicationTitle = 'application_error';
// ignore: constant_identifier_names
const String ErrorFormat = 'format_exception';
// ignore: constant_identifier_names
const String ErrorHttp = 'network_error';
// ignore: constant_identifier_names
const String Error404 = 'page_not_found';
// ignore: constant_identifier_names
const String Error500 = 'was_error_the_server';
// ignore: constant_identifier_names
const String Error401 = 'redirect';
// ignore: constant_identifier_names
const String ErrorSocket = 'cant_connect_server';

// ignore: constant_identifier_names
const String Warning = 'assets/svg/warning.svg';

class MyException {
  static ApiModel getException(DioError e) {
    switch (e.error.runtimeType) {
      case SocketException:
        {
          return ApiModel.fromJson({
            'code': 500,
            "message": <String, dynamic>{
              'title': ErrorApplicationTitle,
              'content': ErrorSocket,
              "image": ''
            },
          });
        }

      case FormatException:
        {
          return ApiModel.fromJson({
            'code': 500,
            "message": <String, dynamic>{
              'title': ErrorApplicationTitle,
              'content': ErrorFormat,
              "image": ''
            },
          });
        }

      case HttpException:
        {
          return ApiModel.fromJson({
            'code': 500,
            "message": <String, dynamic>{
              'title': ErrorApplicationTitle,
              'content': ErrorHttp,
              "image": ''
            },
          });
        }

      default:
        {
          if (e.response == null) {
            return ApiModel.fromJson({
              'code': 500,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': e.message.toString(),
                "image": ''
              },
            });
          } else if (e.response?.statusCode == 500) {
            return ApiModel.fromJson({
              'code': 500,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': e.response?.data.isEmpty
                    ? e.message
                    : e.response?.data['message'],
                "image": ''
              },
            });
          } else if (e.response?.statusCode == 401) {
            return ApiModel.fromJson({
              'code': 401,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': Error401,
                "image": ''
              },
            });
          } else if (e.response?.statusCode == 403) {
            return ApiModel.fromJson({
              'code': 401,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': Error401,
                "image": ''
              },
            });
          } else if (e.response?.statusCode == 404) {
            return ApiModel.fromJson({
              'code': 404,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': Error404,
                "image": ''
              },
            });
          } else {
            return ApiModel.fromJson({
              'code': 500,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': e.message.toString(),
                "image": ''
              },
            });
          }
        }
    }
  }
}
