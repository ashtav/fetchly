part of fetch;

/// A custom extension for the Dio HTTP client.
///
/// This extension adds additional functionality to the Dio client
/// for handling tokens and logging limits.

extension DioCustomExtension on Dio {
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

  /// The character limit for logging HTTP request/response data.
  ///
  /// This property specifies the maximum character limit for logging
  /// HTTP request and response data. Requests or responses exceeding
  /// this limit will be truncated in log messages.
  ///
  /// Example usage:
  /// ```dart
  /// Dio dio = Dio();
  /// int limit = dio.logLimit;
  /// ```

  int get logLimit => 2000;
}
