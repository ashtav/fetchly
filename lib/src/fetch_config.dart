part of fetch;

// manage base url
String _baseUrl = '';

// manage header
Map<String, dynamic> _header = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

// manage request listener
Function(int, dynamic)? _onRequest;

// manage error listener
Function(Object, StackTrace)? _onError;

// manage dio token
Map<String, CancelToken> _cancelTokens = {};

BaseOptions dioOptions({String? baseUrl}) => BaseOptions(
    followRedirects: false,
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 200),
    headers: _header,
    responseType: ResponseType.plain,
    validateStatus: (status) => status! <= 598);

Dio dio = Dio(dioOptions());

class UseFetchly {
  final String? baseUrl;
  final Map<String, dynamic>? header;
  final Function(int statusCode, dynamic data)? onRequest;
  final Function(Object error, StackTrace trace)? onError;

  UseFetchly({this.baseUrl, this.header, this.onRequest, this.onError});

  void init() {
    _baseUrl = baseUrl ?? '';
    _header = header ??
        {'Accept': 'application/json', 'Content-Type': 'application/json'};
    _onRequest = onRequest;
    _onError = onError;
  }
}
