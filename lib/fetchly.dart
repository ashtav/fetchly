/// The `fetchly` library.
///
/// This library provides tools and utilities for making HTTP requests
/// and handling responses. It's built on top of the Dio package,
/// offering a simplified and more specific interface for network operations.
///
/// Exports:
/// - Dio package: A powerful Dart HTTP client for making HTTP requests.
/// - Enumerations: Defines enums used in the library for request handling.
/// - Fetch utilities: Contains classes and methods for performing HTTP requests.

library fetchly;

export 'models/config.dart';
export 'models/request.dart';
export 'models/response.dart';
export 'src/enum.dart';
export 'src/fetch.dart';
export 'utils/api_test.dart';
