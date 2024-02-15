/// Configuration class for Fetchly HTTP client.
///
/// This class holds configuration settings for the Fetchly HTTP client,
/// such as connectTimeout duration and print limit.
class FetchlyConfig {
  /// Timeout duration for HTTP requests, in seconds.
  ///
  /// The default connectTimeout duration is 60 seconds.
  final int connectTimeout;

  /// Limit for printing HTTP response bodies.
  ///
  /// The default connectTimeout duration is 200 seconds.
  final int receiveTimeout;

  /// Limit for printing HTTP response bodies.
  ///
  /// When logging HTTP response bodies, if the body exceeds this limit,
  /// it will be truncated. The default print limit is 2500 characters.
  final int printLimit;

  /// Constructs a FetchlyConfig instance with optional parameters.
  ///
  /// The [connectTimeout] parameter specifies the connectTimeout duration for HTTP requests,
  /// in seconds. The default value is 60 seconds.
  ///
  /// The [receiveTimeout] parameter specifies the receiveTimeout duration for HTTP requests,
  /// in seconds. The default value is 200 seconds.
  ///
  /// The [printLimit] parameter specifies the limit for printing HTTP response bodies.
  /// If the body exceeds this limit, it will be truncated. The default print limit
  /// is 2500 characters.
  ///
  /// Example usage:
  /// ```dart
  /// FetchlyConfig config = FetchlyConfig(connectTimeout: 30, printLimit: 2000);
  /// ```
  FetchlyConfig(
      {this.connectTimeout = 60,
      this.receiveTimeout = 200,
      this.printLimit = 2500});
}
