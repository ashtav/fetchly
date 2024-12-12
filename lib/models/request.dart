/// `Request` is a data model for holding request details.
///
/// It's used to represent data from sources like APIs.
class Request {
  /// The URL of the data source.
  final String url;

  /// The path of the data source.
  final String path;

  /// The status of the request.
  final int status;

  /// The message of the request.
  final String message;

  /// Headers for the request, usually containing metadata.
  final Map<String, dynamic> header;

  /// The data from the request.
  final dynamic data;

  /// Optional log data for additional information.
  final dynamic log;

  /// HTTP method for the request, default is 'GET'.
  final String method;

  /// Payload data for the request.
  final dynamic payload;

  /// Query parameters for the request.
  final dynamic query;

  /// Time request
  final String timeRequest;

  /// Constructor with required `url`, `path`, `status`, and `header`, and optional `log`.
  Request(
      {required this.url,
      required this.path,
      required this.status,
      required this.message,
      required this.header,
      this.data,
      this.log,
      this.method = 'GET',
      this.payload,
      this.query,
      this.timeRequest = '0 ms'});

  /// Converts the object to a map.
  ///
  /// This method is typically used for serialization purposes,
  /// allowing the object to be represented as a key-value map.
  /// It's useful when you need to send data over the network or store it in a format
  /// that requires key-value pairs.
  ///
  /// Returns a [Map<String, dynamic>] containing the object's properties.
  Map<String, dynamic> toMap() => {
        'url': url,
        'path': path,
        'status': status,
        'header': header,
        'data': data,
        'log': log,
        'method': method,
        'payload': payload,
        'query': query,
      };
}
