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

class Fetchly extends ResHandler {
  Future<ResHandler> _fetch(String method, String path,
      {Map<String, dynamic>? query,
      dynamic data,
      Function(int, int)? onReceiveProgress}) async {
    ResHandler result = ResHandler(status: false);
    Stopwatch stopWatch = Stopwatch();

    _cancelTokens[path] = CancelToken();

    try {
      stopWatch.start();
      Response response = await dio.fetch(RequestOptions(
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
      result = await check(response, stopWatch.elapsed.inMilliseconds,
          onRequest: (status, data) {
        _onRequest?.call(path, status, data);
      });
    } catch (e, s) {
      _onError?.call(e, s);
    } finally {
      _cancelTokens.remove(path);
    }

    return result;
  }

  /// ``` dart
  /// ResHandler res = await fetch('GET', 'user', onReceiveProgress: (a, b) {});
  /// ```

  Future<ResHandler> fetch(String method, String path,
      {Map<String, dynamic>? query,
      dynamic data,
      Function(int, int)? onReceiveProgress}) async {
    return await _fetch(method, path,
        query: query, data: data, onReceiveProgress: onReceiveProgress);
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

  Future<ResHandler> post(String path, dynamic data,
          {bool useFormData = false}) async =>
      await _fetch('POST', path,
          data: useFormData ? FormData.fromMap(data) : data);

  /// ``` dart
  /// ResHandler res = await put('user/1', {'name': 'John Doe'});
  /// ```

  Future<ResHandler> put(String path, dynamic data,
          {bool useFormData = false}) async =>
      await _fetch('PUT', path,
          data: useFormData ? FormData.fromMap(data) : data);

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

  /// ``` dart
  /// cancel('<path>');
  /// ```

  void cancel(String path) {
    _cancelTokens[path]?.cancel('Request for $path is canceled');
  }

  /// ``` dart
  /// Fetchly.init(baseUrl: 'https://dummyjson.com/');
  /// ```

  static void init(
      {String? baseUrl,
      Map<String, dynamic>? header,
      void Function(String path, int status, dynamic data)? onRequest,
      void Function(Object error, StackTrace trace)? onError,
      PrintType printType = PrintType.print}) {
    _baseUrl = baseUrl ?? '';
    _header = header ??
        {'Accept': 'application/json', 'Content-Type': 'application/json'};
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
