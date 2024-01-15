/// `Request` is a data model for holding request details.
///
/// It's used to represent data from sources like APIs.
class Request {
  /// The URL of the data source.
  final String url;

  /// Headers for the request, usually containing metadata.
  final Map<String, dynamic> header;

  /// Optional log data for additional information.
  final dynamic log;

  /// Constructor with required `url` and `header`, and optional `log`.
  Request({required this.url, required this.header, this.log});
}
