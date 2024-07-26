import 'request.dart';

/// Represents a response object with various properties such as status, message, data, body, and request.
class Response {
  /// Indicates the status of the response.
  final bool status;

  /// An optional message providing additional information about the response.
  final String? message;

  /// Holds any data returned by the response.
  final dynamic data;

  /// Represents the body of the response, can hold any type of data.
  final dynamic body;

  /// The original request that resulted in this response.
  final Request? request;

  /// Constructs a [Response] object with optional properties.
  ///
  /// The [status] defaults to `false` if not provided.
  /// [message], [data], [body], and [request] are optional and can be `null`.
  Response(
      {this.status = false, this.message, this.data, this.body, this.request});

  /// Converts the object to a map.
  ///
  /// This method is typically used for serialization purposes,
  /// allowing the object to be represented as a key-value map.
  /// It's useful when you need to send data over the network or store it in a format
  /// that requires key-value pairs.
  ///
  /// Returns a [Map<String, dynamic>] containing the object's properties.
  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'data': data,
        'body': body,
        'request': request?.toMap(), // Assumes Request has a toMap() method
      };
}
