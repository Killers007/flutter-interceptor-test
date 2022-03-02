// ignore_for_file: constant_identifier_names

import 'package:desktop_app/model/model_api.dart';
import 'package:dio/dio.dart';
import 'package:dio_log/dio_log.dart';
import 'exception.dart';
import 'interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum MethodRequest { GET, POST, PUT, DELETE }

class ApiConsumer {
  ///Singleton factory
  static final ApiConsumer _instance = ApiConsumer._internal();

  /*
    * Ini adalah method static yang mengontrol akses ke singleton
    * instance. Saat pertama kali dijalankan, akan membuat objek tunggal dan menempatkannya
    * ke dalam array statis. Pada pemanggilan selanjutnya, ini mengembalikan klien yang ada
    * pada objek yang disimpan di array statis.
    *
    * Implementasi ini memungkinkan Anda membuat subclass kelas Singleton sambil mempertahankan
    * hanya satu instance dari setiap subclass sekitar.
    * @return ApiConsumer
    */

  String? apiUrl;
  String? apiKey;
  String? appId;
  String? apiToken;
  int? apiTimeout;

  ApiConsumer._internal();

  factory ApiConsumer(
      {required String apiUrl,
      String? apiKey,
      String? appId,
      int? apiTimeout,
      String? apiToken}) {
    _instance.apiUrl = apiUrl;
    _instance.apiKey = apiKey;
    _instance.appId = appId;
    _instance.apiToken = apiToken;
    _instance.apiTimeout = apiTimeout;
    return _instance;
  }

  final int timeout = 20; //Seconds

  int? limits;
  Map<String, dynamic>? orders;
  Map<String, dynamic>? fillters;

  /*
   * Request ke API
   */
  Future<ApiModel> execute(
      {required String url,
      FormData? formData,
      String? getData,
      MethodRequest method = MethodRequest.GET}) async {
    try {
      String urlRequest = url + generateQuery();

      // Application.preferences = await SharedPreferences.getInstance();
      BaseOptions options = BaseOptions(
        headers: {
          'AppId': appId,
          'X-ApiKey': apiKey,
          'X-Token': apiToken,
        },
        baseUrl: apiUrl!,
        method: _convertMethod(method),
        connectTimeout: timeout * 1000,
        receiveTimeout: timeout * 1000,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      );

      Dio dio = Dio(options);

      dio.interceptors.add(CustomInterceptors(dio));
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
      ));
      dio.interceptors.add(DioLogInterceptor());

      _cleanFillter();
      Response<Map<String, dynamic>> res =
          await dio.request(urlRequest, data: formData);

      ApiModel apiModel = ApiModel.fromJson(res.data);

      if (apiModel.code == CODE.ERROR) {
        return ApiModel.fromJson({
          'code': 500,
          "message": <String, dynamic>{
            'title': ErrorApplicationTitle,
            'content': apiModel.message,
            "image": Warning
          },
        });
      }

      return apiModel;
    } on DioError catch (e) {
      final exception = MyException.getException(e);
      return exception;
    }
  }

  /*
   * Autentikasi
   */
  Future<ApiModel> auth({String? username, String? password}) async {
    FormData formData =
        FormData.fromMap({"username": username, 'password': password});

    return await execute(
        url: '/auth', formData: formData, method: MethodRequest.POST);
  }

  /*
   * Validate Refresh Token Jika masih berlaku
   */
  Future<ApiModel> validateToken(String token) async {
    FormData formData = FormData.fromMap({"tokenRefresh": token});

    return await execute(
        url: '/auth/refresh', formData: formData, method: MethodRequest.PUT);
  }

  _cleanFillter() {
    fillters = {};
    orders = {};
    limits = null;
    return this;
  }

  /* 
   * Generate Query API
   */
  generateQuery() {
    String _tempOrder = '';
    String _tempFillter = '';

    orders?.forEach((key, value) {
      _tempOrder += '&$key[sort]=$value';
    });

    fillters?.forEach((key, value) {
      _tempFillter += _applyQueryFilter(key, value);
    });

    String _tempLimit = limits != null ? '&limit=$limits' : '';

    String _combineFillter = _tempFillter + _tempOrder + _tempLimit;
    _combineFillter =
        _combineFillter.isNotEmpty ? _combineFillter.substring(1) : '';
    return _combineFillter != '' ? '?' + _combineFillter : '';
  }

  /* 
   * Private Method Fillter Query
   */
  _applyQueryFilter(String key, String value) {
    final split = key.split(" ");
    final splitKey = split[0];

    String splitValue = split.length > 1 ? split[1] : '';
    switch (splitValue) {
      case '=':
        splitValue = '';
        break;
      case '>=':
        splitValue = '[gte]';
        break;
      case '>':
        splitValue = '[gt]';
        break;
      case '<':
        splitValue = '[lt]';
        break;
      case '<=':
        splitValue = '[lte]';
        break;
      case '!=':
        splitValue = '[nq]';
        break;
      case 'is_null':
        splitValue = '[is_null]';
        break;
      case 'not_null':
        splitValue = '[not_null]';
        break;
      case 'in':
        splitValue = '[in]';
        break;
      case 'not_in':
        splitValue = '[not_in]';
        break;
      case 'like':
        splitValue = '[like]';
        break;
      case 'or_like':
        splitValue = '[or_like]';
        break;
      default:
        splitValue = '[eq]';
    }
    return "&$splitKey$splitValue=$value";
  }

  /* 
   * Limit data
   */
  limit(int limit) {
    limits = limit;
    return this;
  }

  /* 
   * Order Data
   */
  orderBy(Map<String, dynamic> order) {
    orders = order;
    return this;
  }

  /* 
   * Fillter Data
   */
  where(Map<String, dynamic> fillter) {
    fillters = fillter;
    return this;
  }

  // Private convert method
  String _convertMethod(MethodRequest method) {
    switch (method) {
      case MethodRequest.POST:
        return 'POST';
      case MethodRequest.PUT:
        return 'PUT';
      case MethodRequest.DELETE:
        return 'DELETE';
      default:
        return 'GET';
    }
  }
}
