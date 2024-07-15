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

  /// Flag indicating whether to show HTTP headers in logs.
  ///
  /// If set to true, HTTP headers will be printed in the logs.
  /// The default value is false.
  final bool showHeader;

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
  /// The [showHeader] parameter specifies whether HTTP headers should be printed in the logs.
  /// The default value is false.
  ///
  /// Example usage:
  /// ```dart
  /// FetchlyConfig config = FetchlyConfig(connectTimeout: 30, printLimit: 2000);
  /// ```
  FetchlyConfig(
      {this.connectTimeout = 60,
      this.receiveTimeout = 200,
      this.printLimit = 2500,
      this.showHeader = false});

  /// Creates a new instance of FetchlyConfig by copying the current instance and
  /// replacing specified values with new ones.
  ///
  /// Returns a new FetchlyConfig instance with updated values. If a parameter
  /// is not provided, its value remains the same as in the current instance.
  FetchlyConfig copyWith(
      {int? connectTimeout,
      int? receiveTimeout,
      int? printLimit,
      bool? showHeader}) {
    return FetchlyConfig(
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      printLimit: printLimit ?? this.printLimit,
      showHeader: showHeader ?? this.showHeader,
    );
  }
}
