part of fetch;

/// A custom extension for the Dio HTTP client.
///
/// This extension adds additional functionality to the Dio client
/// for handling tokens and logging limits.

extension DioCustomExtension on _dio.Dio {
  /// Set an authentication token in the HTTP headers.
  ///
  /// Use this method to easily set an authentication token in the headers
  /// of Dio requests. You can specify an optional [prefix] to add before
  /// the token (e.g., 'Bearer'), which is commonly used for authorization.
  ///
  /// Example usage:
  /// ```dart
  /// Dio dio = Dio();
  /// dio.setToken('your_token', prefix: 'Bearer');
  /// ```

  void setToken(String? token, {String? prefix}) {
    dio.options.headers['authorization'] =
        prefix == null ? 'Bearer $token' : '$prefix $token';
  }

  /// Set custom headers in the HTTP request.
  ///
  /// Use this method to easily set custom headers in the headers
  /// of Dio requests. You can specify a [Map] of headers to be set.
  ///
  /// Example usage:
  /// ```dart
  /// Dio dio = Dio();
  /// dio.setHeader({'Authorization': 'Bearer your_token', 'Content-Type': 'application/json'});
  /// ```
  ///
  /// Note: This method will override any existing headers set in the Dio instance.
  ///
  /// See also:
  /// - [setToken], for setting an authentication token with an optional prefix.
  void setHeader(Map<String, dynamic> headers) {
    dio.options.headers = headers;
  }
}

/// A custom extension for converting map data to FormData.
///
/// This extension provides a convenient method for converting a map
/// to FormData, which is commonly used for HTTP requests with Dio.
///
/// Example usage:
/// ```dart
/// Map<String, dynamic> payload = {'name': 'John Doe'};
/// FormData formData = payload.toFormData();
/// ```
extension FetchlyMapExtension on Map<String, dynamic> {
  /// Convert the map data to FormData.
  ///
  /// This method converts the map data to FormData, which is suitable
  /// for use in HTTP requests with Dio. You can optionally specify
  /// [collectionFormat] and [camelCaseContentDisposition] parameters.
  ///
  /// Example usage:
  /// ```dart
  /// Map<String, dynamic> payload = {'name': 'John Doe'};
  /// FormData formData = payload.toFormData();
  /// ```
  _dio.FormData toFormData(
      [_dio.ListFormat collectionFormat = _dio.ListFormat.multi,
      bool camelCaseContentDisposition = false]) {
    return _dio.FormData.fromMap(
        this, collectionFormat, camelCaseContentDisposition);
  }
}
