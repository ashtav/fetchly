// Author: Ashta
// Last Modified: 2023/07/31 11:21:21
// Description: Handles the response from the server

// Why do we need Response Handler?
// 1. Adjust the response to our needs (status, message, data)
// 2. Handle error from the server
// 3. Show the request information and response in debug console

// The response must be in this format:
// {
//   "status": true,
//   "message": "Data has been loaded",
//   "data": [] or {},
// }

part of fetch;

/// A utility class for handling HTTP response data.
///
/// The `ResHandler` class is used to encapsulate information commonly found in
/// HTTP responses, such as status, messages, data, and the raw response body.
///
/// Parameters:
///   - [status]: A boolean indicating the status of the response. Default is `false`.
///   - [message]: An optional message associated with the response.
///   - [data]: The data payload of the response.
///   - [body]: The raw response body, which can be of any data type.

class ResHandler {
  final bool status;
  final String? message;
  final dynamic data, body;
  final Request? request;

  ResHandler(
      {this.status = false, this.message, this.data, this.body, this.request});

  /// A function to check and process an HTTP response.
  ///
  /// This function is used to examine an HTTP response and process it based on
  /// various criteria, such as status code, response time, and an optional
  /// [onRequest] callback.
  Future<ResHandler> check(Response response, int time,
      {Function(Request request)? onRequest}) async {
    RequestOptions req = response.requestOptions;

    // request information
    String baseUrl = req.baseUrl,
        method = req.method,
        path = req.path,
        statusMessage = response.statusMessage ?? 'No status message';

    int? statusCode = response.statusCode;
    dynamic responseData = response.data;

    Map<String, dynamic> query = req.queryParameters;

    // TIME REQUEST ----------------------------------------------------------------------------------------------------
    // get the time request

    String timeRequest = '${time / 1000} ${time >= 1000 ? "s" : "ms"}';

    // DEBUG CONSOLE ---------------------------------------------------------------------------------------------------
    // show the request information in debug console

    String requestOptions = req.data.toString();

    if (req.data is FormData) {
      dynamic fields = req.data.fields;
      requestOptions += ' | ';

      if (fields is List) {
        for (var f in fields) {
          if (f is MapEntry) {
            requestOptions += '${f.key}: ${f.value}, ';
          }
        }
      }
    }

    String requestInfo = '$path, $statusCode ($statusMessage), $timeRequest';
    List<String> consoleMessages = [
      '[$method] $requestInfo',
      'query: $query',
      'body: $requestOptions',
      'response: $responseData'
    ];

    if (query.isEmpty) consoleMessages.removeAt(1);
    if (requestOptions.isEmpty || requestOptions == 'null') {
      consoleMessages.removeAt(consoleMessages.length == 3 ? 1 : 2);
    }

    String debugMessage = consoleMessages.map((e) => '-- $e\n').join();
    String logMessage = '';

    // statusCode = null is usually when the server is not available or request is timeout
    if (statusCode != null) {
      // print request information
      final now = DateTime.now();
      final dateTime = Utils.dateFormat(now);

      String dtBaseUrl = '== $dateTime | $baseUrl';
      logMessage = '$dtBaseUrl\n$debugMessage';

      ansiColorDisabled = false;
      final pen = AnsiPen()
        ..white()
        ..cyan(bg: true);

      final pen2 = AnsiPen()..cyan();

      if (_printType == PrintType.log) {
        logg(pen(dtBaseUrl));
        logg(pen2(debugMessage), limit: _config.printLimit);
      } else if (_printType == PrintType.print) {
        devPrint(pen(dtBaseUrl));

        debugMessage.split('\n').forEach((line) async {
          devPrint(pen2(line), limit: _config.printLimit);
        });
      }
    }

    List<int> okStatus = [200, 201, 202];
    bool ok = okStatus.contains(statusCode);

    // HANDLE RESPONSE DATA --------------------------------------------------------------------------------------------
    // adjust the response data to our needs

    String? message;
    dynamic data;

    if (responseData != null) {
      try {
        // try convert data to json
        Map<String, dynamic> map = json.decode(responseData);

        // get the status, message, and data from the response
        message = map['message'] ?? 'No message found';
        data = map['data'];

        // check property status in the response
        // if property status is not found, make status code as the status

        if (map['status'] != null) {
          ok = map['status'] is bool
              ? map['status']
              : okStatus.contains(statusCode);
        } else {
          ok = okStatus.contains(statusCode);
        }

        // if status code is 500, we need to get the error message from the server

        if (statusCode == 500) {
          message = 'Internal server error';
        } else if (statusCode == 422) {
          // if the response is 422, we need to get the error message from the server
          if (map['errors'] != null) {
            Map.from(map['errors']).forEach((key, value) {
              if (value is List && value.toList().isNotEmpty) {
                message = value[0];
              }
            });
          }
        }

        responseData = map;
      } catch (e) {
        // if failed, let it be default
      }
    }

    final request = Request(
        url: baseUrl,
        path: path,
        status: statusCode ?? 0,
        header: req.headers,
        data: data,
        log: logMessage);

    onRequest?.call(request);

    // return the response
    return ResHandler(
        status: ok,
        message: message ?? response.statusMessage,
        data: data,
        body: responseData,
        request: request);
  }

  /// Converts the object to a map.
  ///
  /// This method is typically used for serialization purposes,
  /// allowing the object to be represented as a key-value map.
  /// It's useful when you need to send data over the network or store it in a format
  /// that requires key-value pairs.
  ///
  /// Returns a [Map<String, dynamic>] containing the object's properties.
  Map<String, dynamic> toMap() =>
      {'status': status, 'message': message, 'data': data};
}
