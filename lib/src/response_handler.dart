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

class ResHandler {
  final bool status;
  final String? message;
  final dynamic data, body;

  ResHandler({this.status = false, this.message, this.data, this.body});

  Future<ResHandler> check(Response response, int time,
      {Function(int statusCode, dynamic data)? onRequest}) async {
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

    // statusCode = null is usually when the server is not available or request is timeout
    if (statusCode != null) {
      // print request information

      logg('\n== BASE URL : $baseUrl');
      logg(debugMessage, color: LogColor.cyan, limit: dio.logLimit);
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
        data = map['data'] ?? map;

        // check property status in the response
        // if property status is not found, make status code as the status

        if (map['status'] != null) {
          ok = map['status'] is bool ? map['status'] : okStatus.contains(statusCode);
        } else {
          ok = okStatus.contains(statusCode);
        }

        // if statis code is 500, we need to get the error message from the server

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

    onRequest?.call(statusCode ?? 0, responseData);
    return ResHandler(
        status: ok,
        message: message ?? response.statusMessage,
        data: data,
        body: responseData);
  }
}
