import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:quickseatreservation/app/constants/AppKeys.dart';
import 'package:quickseatreservation/app/constants/AppTexts.dart';
import 'package:quickseatreservation/core/prefs/PrefsHelper.dart';
import 'BaseApiServices.dart';
import 'LoggingInterceptor.dart';

class DioClient implements BaseApiServices {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;

  Dio? dio;
  String? token;
  String? countryCode;

  DioClient._(this.baseUrl, {required this.loggingInterceptor});

  /// Async factory (because constructor cannot be async)
  static Future<DioClient> create(
    String baseUrl, {
    required LoggingInterceptor loggingInterceptor,
    Dio? dioC,
  }) async {
    final client = DioClient._(baseUrl, loggingInterceptor: loggingInterceptor);

    client.token = await PrefsHelper.getString(AppKeys.userLoginToken);
    client.countryCode =
        await PrefsHelper.getString(AppKeys.countryCode) ?? "91";

    client.dio = dioC ?? Dio();

    client.dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${client.token}',
        'Accept': 'application/json',
        AppText.langKey: client.countryCode == 'US'
            ? 'en'
            : client.countryCode!.toLowerCase(),
      };

    client.dio!.interceptors.add(loggingInterceptor);

    return client;
  }

  /// Update token & language dynamically (after login / change country)
  void updateHeader(String? token, String? countryCode) {
    this.token = token ?? this.token;
    this.countryCode = countryCode ?? this.countryCode;

    dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${this.token}',
      AppKeys.countryCode: this.countryCode == 'US'
          ? 'en'
          : this.countryCode!.toLowerCase(),
    };
  }

  @override
  Future<Response> getGetApiResponse(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final fullUrl = dio!.options.baseUrl + uri;
    debugPrint("DIO GET ===> $fullUrl");

    try {
      return await dio!.get(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> getPostApiResponse(
    bool isSecure,
    String uri,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final fullUrl = dio!.options.baseUrl + uri;
    debugPrint("DIO POST ===> $fullUrl");

    try {
      return await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> postMultipartApiResponse(
    String uri,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio!.post(
        uri,
        data: formData,
        queryParameters: queryParameters,
        options: options ?? Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> putApiResponse(
    String uri,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> deleteApiResponse(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> getPatchApiResponse(
    String uri,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio!.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> getDownloadResponse(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    String? filePath,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final fullPath = filePath ?? path.join(directory.path, 'download.pdf');

    try {
      return await dio!.download(uri, fullPath);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
