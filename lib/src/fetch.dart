library fetch;

import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:dio/dio.dart';
import 'package:fetchly/models/request.dart';
import 'package:fetchly/src/enum.dart';
import 'package:fetchly/utils/utils.dart';

import '../utils/log.dart';

part 'extension.dart';
part 'fetch_config.dart';
part 'response_handler.dart';

/// The `Fetchly` class extends `ResHandler` to handle HTTP requests.
class Fetchly extends ResHandler {
  /// Performs an HTTP request using the Dio package with specified parameters.
  ///
  /// This method manages the entire lifecycle of an HTTP request from
  /// sending the request to handling the response. It's designed to be
  /// flexible, allowing various customizations for the request.
  ///
  /// [method]: The HTTP method to be used (GET, POST, etc.).
  /// [path]: The URL path for the request.
  /// [query]: Optional. Contains query parameters for the request.
  /// [data]: Optional. Contains the body data to be sent with the request.
  /// [onReceiveProgress]: Optional. A callback function for tracking progress.
  ///
  /// The method utilizes a `CancelToken` for each path, allowing requests to be cancelled.
  /// It also uses a `Stopwatch` to measure the duration of the request.
  ///
  /// Error handling is done using `try-catch` blocks, specifically catching `DioException`.
  /// On completion or error, the relevant cancel token is removed.
  ///
  /// Returns: A `ResHandler` object containing the response status and data.
  ///
  /// Note: `_cancelTokens` should be defined to store and manage `CancelToken` instances.
  /// `dio` should be an instance of the Dio client with configured options.

  Future<ResHandler> _fetch(String method, String path,
      {Map<String, dynamic>? query, dynamic data, Function(int, int)? onReceiveProgress}) async {
    ResHandler result = ResHandler(status: false);
    Stopwatch stopWatch = Stopwatch();

    // Assigning a CancelToken for the request based on the path.
    _cancelTokens[path] = CancelToken();
    _currentToken = _cancelTokens[path];
    _currentPath = path;

    try {
      // Starting the stopwatch to measure request time.
      stopWatch.start();

      // Making the HTTP request with provided parameters and Dio options.
      Response response = await dio.fetch(RequestOptions(
          // RequestOptions configured with the provided parameters and Dio's default settings.
          baseUrl: dio.options.baseUrl,
          method: method,
          path: path,
          queryParameters: query,
          data: data,
          onReceiveProgress: onReceiveProgress,
          followRedirects: dio.options.followRedirects,
          connectTimeout: dio.options.connectTimeout,
          receiveTimeout: dio.options.receiveTimeout,
          headers: dio.options.headers,
          responseType: dio.options.responseType,
          validateStatus: dio.options.validateStatus,
          cancelToken: _cancelTokens[path]));

      stopWatch.stop();

      // Processing the response.
      result = await check(response, stopWatch.elapsed.inMilliseconds, onRequest: (request) {
        _onRequest?.call(request);
      });
    } on DioException catch (e, s) {
      // Handling Dio-specific exceptions.
      if (![DioExceptionType.cancel].contains(e.type)) {
        _onError?.call(e, s);
      }
    } catch (e, s) {
      // General error handling.
      _onError?.call(e, s);
    } finally {
      // Cleanup: removing the CancelToken for this path.
      _cancelTokens.remove(path);
    }

    return result;
  }

  /// ``` dart
  /// ResHandler res = await fetch('GET', 'user', onReceiveProgress: (a, b) {});
  /// ```

  Future<ResHandler> fetch(String method, String path,
      {Map<String, dynamic>? query, dynamic data, Function(int, int)? onReceiveProgress}) async {
    return await _fetch(method, path, query: query, data: data, onReceiveProgress: onReceiveProgress);
  }

  /// ``` dart
  /// ResHandler res = await get('user');
  /// ```

  Future<ResHandler> get(String path, [Map<String, dynamic>? query]) async {
    return await _fetch('GET', path, query: query);
  }

  /// ``` dart
  /// ResHandler res = await post('user', {'name': 'John Doe'});
  /// ```

  Future<ResHandler> post(String path, dynamic data, {bool useFormData = false}) async =>
      await _fetch('POST', path, data: useFormData ? FormData.fromMap(data) : data);

  /// ``` dart
  /// ResHandler res = await put('user/1', {'name': 'John Doe'});
  /// ```

  Future<ResHandler> put(String path, dynamic data, {bool useFormData = false}) async =>
      await _fetch('PUT', path, data: useFormData ? FormData.fromMap(data) : data);

  /// ``` dart
  /// ResHandler res = await delete('user/1');
  /// ```

  Future<ResHandler> delete(String path) async => await _fetch('DELETE', path);

  /// ``` dart
  /// String path = '/storage/emulated/0/Download/1.jpg';
  /// final file = await toFile(path);
  /// ```

  Future<MultipartFile> toFile(String path) async {
    return await MultipartFile.fromFile(path);
  }

  /// Cancels an ongoing HTTP request.
  ///
  /// This method is used to cancel an ongoing HTTP request that is associated
  /// with a specific path or the current request if no path is provided. When
  /// a path is provided, it looks up the corresponding cancellation token and
  /// uses it to cancel the request. If no path is provided, it cancels the
  /// current request.
  ///
  /// The cancellation of the request is logged for debugging purposes.
  ///
  /// Usage:
  /// To cancel a specific request:
  /// ```dart
  /// cancel('path/to/request');
  /// ```
  ///
  /// To cancel the current request (if no other path is specified):
  /// ```dart
  /// cancel();
  /// ```
  ///
  /// Parameters:
  /// - [path] (optional): The path of the request to be canceled. If no path
  ///   is provided, the current request is canceled.
  ///
  /// Note: The cancellation token associated with the path (if provided) is
  /// removed from the tracking list after the cancellation.

  void cancel([String? path]) {
    final token = _cancelTokens[path];

    // cancel specific request
    if (path != null && token != null) {
      token.cancel('Request for $path is canceled');
      logg('Request for $path is canceled', name: 'Fetchly');
    }

    // cancel current request
    else if (_currentToken != null) {
      _currentToken?.cancel('Request is canceled');
      logg('Request for $_currentPath is canceled', name: 'Fetchly');
    }
  }

  /// ``` dart
  /// Fetchly.init(baseUrl: 'https://dummyjson.com/');
  /// ```

  static void init(
      {String? baseUrl,
      Map<String, dynamic>? header,
      void Function(Request request)? onRequest,
      void Function(Object error, StackTrace trace)? onError,
      PrintType printType = PrintType.print}) {
    _baseUrl = baseUrl ?? '';
    _header = header ?? {'Accept': 'application/json', 'Content-Type': 'application/json'};
    _onRequest = onRequest;
    _onError = onError;
    _printType = printType;
  }

  /// ``` dart
  /// Fetchly.setHeader({'Authorization': 'Bearer token'});
  /// ```

  static void setHeader(Map<String, dynamic> header, {bool merge = true}) {
    if (merge) {
      // prevent duplicate header
      header.removeWhere((key, value) => _header.containsKey(key));
      return _header.addAll(header);
    }

    _header = header;
  }
}
