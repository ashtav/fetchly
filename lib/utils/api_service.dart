import 'package:fetchly/fetchly.dart';
import 'package:flutter/foundation.dart';

/// A service class extending [Fetchly] for managing API-related functionality.
///
/// The `ApiServices` class provides utilities for setting an authentication
/// token and performing grouped requests in an efficient manner.
class ApiServices extends Fetchly {
  /// Sets the authentication token for API requests.
  ///
  /// This method sets a token globally for all subsequent API requests made
  /// through the `Fetchly` library. The token can be prefixed with a specified
  /// string (default: `'Bearer'`).
  ///
  /// Example:
  /// ```dart
  /// apiServices.setToken('your-token-here');
  /// ```
  ///
  /// [token]: The authentication token to be used.
  /// [prefix]: An optional prefix for the token (default: `'Bearer'`).
  void setToken(String token, {String prefix = 'Bearer'}) {
    Fetchly.setToken(token, prefix: prefix);
  }

  /// Executes a group of API requests concurrently and returns their responses.
  ///
  /// The method takes a list of [Future] API requests and waits for all of them
  /// to complete. The responses are then returned as a list in the same order
  /// as the input requests.
  ///
  /// Example:
  /// ```dart
  /// List<Future<Response>> requests = [
  ///   api.get('/endpoint1'),
  ///   api.get('/endpoint2'),
  /// ];
  ///
  /// List<Response> responses = await apiServices.group(requests);
  /// ```
  ///
  /// [requests]: A list of [Future<Response>] objects representing the API requests.
  ///
  /// Returns a [Future] containing a list of [Response] objects.
  Future<List<Response>> group(List<Future<Response>> requests) async {
    List<Response> responses = [];

    await Future.forEach(requests, (req) async {
      final res = await req;
      responses.add(res);
    });

    return responses;
  }

  /// Sends a protected GET request to the specified [path] with optional [query].
  @override
  @protected
  Future<Response> get(String path, [Map<String, dynamic>? query]) async {
    return Response();
  }

  /// Sends a protected POST request to the specified [path] with optional [data].
  @override
  @protected
  Future<Response> post(String path, [dynamic data]) async => Response();

  /// Sends a protected PUT request to the specified [path] with optional [data].
  @override
  @protected
  Future<Response> put(String path, [dynamic data]) async => Response();

  /// Sends a protected DELETE request to the specified [path].
  @override
  @protected
  Future<Response> delete(String path) async => Response();

  /// Sends a protected request using [method] to the specified [path] with optional parameters.
  @override
  @protected
  Future<Response> fetch(String method, String path,
          {Map<String, dynamic>? query,
          dynamic data,
          Function(int, int)? onReceiveProgress}) async =>
      Response();

  /// Override and protected toString method
  @override
  @protected
  String toString() => '';
}
