part of fetch;

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
Map<String, CancelToken> _cancelTokens = {};

// manage current token
CancelToken? _currentToken;

// manage current path
String? _currentPath;

// print type
PrintType _printType = PrintType.print;

/// Get Dio options with configurable parameters.
///
/// This method returns a [BaseOptions] object with various parameters
/// set, including the base URL, headers, timeouts, and more for the Dio client.
BaseOptions dioOptions({String? baseUrl}) => BaseOptions(
    followRedirects: false,
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 200),
    headers: _header,
    responseType: ResponseType.plain,
    validateStatus: (status) => status! <= 598);

/// The Dio client instance with the configured options.
///
/// This Dio client instance is initialized with the Dio options
/// configured in [dioOptions].
Dio dio = Dio(dioOptions());
