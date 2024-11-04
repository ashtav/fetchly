part of 'fetch.dart';

/// A configuration manager for Fetchly.
///
/// This section of code manages the base URL, headers, request listener,
/// error listener, Dio tokens, and Dio configuration options for Fetchly.

// manage base url
String _baseUrl = '';

// manage header
Map<String, dynamic> _header = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

// manage request listener
void Function(Request request)? _onRequest;

// manage error listener
void Function(Object, StackTrace)? _onError;

// manage dio token
Map<String, _dio.CancelToken> _cancelTokens = {};

// manage current token
_dio.CancelToken? _currentToken;

// manage current path
String? _currentPath;

// print type
PrintType _printType = PrintType.log;

// fetchly config
FetchlyConfig _config = FetchlyConfig();

/// Creates a set of base options for Dio HTTP client.
///
/// This function sets up basic configurations for the Dio client,
/// useful for making HTTP requests. The options include disabling
/// follow redirects, setting base URL, connection timeout, receive timeout,
/// custom headers, response type, and a custom status validation.
///
/// [baseUrl] (optional): Allows specifying a base URL that will be used for each
/// request made with the Dio client. If not provided, `_baseUrl` (a global variable)
/// is used as the default.
///
/// Returns a `BaseOptions` object configured with the provided settings.
_dio.BaseOptions dioOptions({String? baseUrl}) => _dio.BaseOptions(
    followRedirects: false,
    baseUrl: _baseUrl,
    connectTimeout: Duration(seconds: _config.connectTimeout),
    receiveTimeout: Duration(seconds: _config.receiveTimeout),
    headers: _header,
    responseType: _dio.ResponseType.plain,
    validateStatus: (status) => status! <= 598);

/// The Dio client instance with the configured options.
///
/// This Dio client instance is initialized with the Dio options
/// configured in [dioOptions].
_dio.Dio dio = _dio.Dio(dioOptions());
