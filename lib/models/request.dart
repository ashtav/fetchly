class Request {
  final String url;
  final Map<String, dynamic> header;
  final dynamic log;

  Request({required this.url, required this.header, this.log});
}
