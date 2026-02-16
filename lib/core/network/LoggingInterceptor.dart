import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quickseatreservation/app/constants/AppKeys.dart';
import 'package:quickseatreservation/core/prefs/PrefsHelper.dart';

class LoggingInterceptor extends Interceptor {
  final int _maxLineLength = 5000;
  final _requestTimes = <String, DateTime>{};
  static const _jsonEncoder = JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Inject token dynamically
    final token = PrefsHelper.getString(AppKeys.userLoginToken);
    if (token.toString().isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      final requestId = UniqueKey().toString();
      options.extra['requestId'] = requestId;
      _requestTimes[requestId] = DateTime.now();

      log('🌐 ➡️ REQUEST [${options.method}]', name: 'Dio');
      log('🔹 URL: ${options.uri}', name: 'Dio');
      if (options.headers.isNotEmpty) {
        _printWrapped('🔹 Headers: ${jsonEncode(options.headers)}');
      }

      if (options.data != null) {
        try {
          final body = _jsonEncoder.convert(options.data);
          _printWrapped('🟨 Body:\n$body');
        } catch (_) {
          _printWrapped('🟨 Body: ${options.data}');
        }
      }

      log('⏳ Sending request...\n', name: 'Dio');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final requestId = response.requestOptions.extra['requestId'];
      final startTime = requestId != null
          ? _requestTimes.remove(requestId)
          : null;
      final elapsed = startTime != null
          ? DateTime.now().difference(startTime).inMilliseconds
          : null;

      log(
        '🟩 <-- RESPONSE [${response.statusCode}] ${response.requestOptions.method} ${response.requestOptions.path}',
        name: 'Dio',
      );
      if (elapsed != null) log('⏱️ Duration: ${elapsed}ms', name: 'Dio');

      final data = response.data;
      if (data != null) {
        try {
          final pretty = _jsonEncoder.convert(data);
          _printWrapped(pretty);
        } catch (_) {
          _printWrapped(data.toString());
        }
      }

      log('🟩 <-- END HTTP\n', name: 'Dio');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final requestId = err.requestOptions.extra['requestId'];
      _requestTimes.remove(requestId);

      log(
        '🟥 <-- ERROR [${err.response?.statusCode ?? 'NO STATUS'}]',
        name: 'Dio',
      );
      log('🔹 PATH: ${err.requestOptions.path}', name: 'Dio');
      log('🔹 MESSAGE: ${err.message}', name: 'Dio');

      final data = err.response?.data;
      if (data != null) {
        try {
          final pretty = _jsonEncoder.convert(data);
          _printWrapped(pretty);
        } catch (_) {
          _printWrapped(data.toString());
        }
      }

      log('🟥 <-- END ERROR\n', name: 'Dio');
    }

    handler.next(err);
  }

  void _printWrapped(String text) {
    if (text.isEmpty) return;
    final pattern = RegExp('.{1,$_maxLineLength}');
    for (final match in pattern.allMatches(text)) {
      debugPrint(match.group(0));
    }
  }
}
