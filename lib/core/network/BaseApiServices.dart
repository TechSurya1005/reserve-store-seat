import 'package:dio/dio.dart';

abstract class BaseApiServices {
  Future<Response> getGetApiResponse(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response> getPostApiResponse(
    bool isSecure,
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response> postMultipartApiResponse(
    String url,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response> putApiResponse(
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response> deleteApiResponse(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<Response> getPatchApiResponse(
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Response> getDownloadResponse(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    String? filePath,
  });
}
