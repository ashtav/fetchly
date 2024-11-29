part of 'fetch.dart';

/// A utility class for handling HTTP response data.
///
/// The `Response` class is used to encapsulate information commonly found in
class ResponseHandler {
  /// A function to check and process an HTTP response.
  ///
  /// This function is used to examine an HTTP response and process it based on
  /// various criteria, such as status code, response time, and an optional
  /// [onRequest] callback.
  @protected
  Future<Response> check(_dio.Response response, int time,
      {Function(Request request)? onRequest}) async {
    _dio.RequestOptions req = response.requestOptions;

    // request information
    String baseUrl = req.baseUrl,
        method = req.method,
        path = req.path,
        statusMessage = response.statusMessage ?? 'No status message';

    // if the path contains http, we need to parse it to get the base url and path
    Uri uri = Uri.parse(path);

    if (uri.scheme.contains('http')) {
      baseUrl = '${uri.scheme}://${uri.host}';
      path = uri.path;
    }

    int? statusCode = response.statusCode;
    dynamic responseData = response.data;

    Map<String, dynamic> query = {};

    if (req.queryParameters.isNotEmpty && uri.queryParameters.isNotEmpty) {
      query.addAll(uri.queryParameters);
      query.addAll(req.queryParameters);
    } else if (req.queryParameters.isNotEmpty) {
      query = req.queryParameters;
    } else if (uri.queryParameters.isNotEmpty) {
      query = uri.queryParameters;
    }

    // TIME REQUEST ----------------------------------------------------------------------------------------------------
    // get the time request

    String timeRequest = '${time / 1000} ${time >= 1000 ? "s" : "ms"}';

    // DEBUG CONSOLE ---------------------------------------------------------------------------------------------------
    // show the request information in debug console

    String requestOptions = req.data.toString();

    if (req.data is _dio.FormData) {
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
    Map<String, dynamic> mapInfo = {'request': '[$method] $requestInfo'};

    // show headers
    if (_config.showHeader) {
      String header = req.headers.toString();
      int headerLimit = _config.headerLimit;

      header = header.length > headerLimit
          ? '${header.substring(0, headerLimit)}...${header.substring(header.length - 10, header.length)}'
          : header;

      mapInfo['header'] = 'headers: $header';
    }

    // show body
    if (!['', 'null', null].contains(requestOptions)) {
      mapInfo['body'] = 'body: $requestOptions';
    }

    // show query
    if (query.isNotEmpty) {
      mapInfo['query'] = 'query: $query';
    }

    mapInfo['response'] = 'response: $responseData';

    List<String> consoleMessages =
        mapInfo.keys.map((k) => mapInfo[k].toString()).toList();

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
    dynamic dataBody;

    if (responseData != null) {
      try {
        // try convert data to json
        Map<String, dynamic> map = json.decode(responseData);

        // get the status, message, and data from the response
        message = map['message'] ?? 'No message found';
        dataBody = map['data'];

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
        method: method,
        query: query,
        payload: requestOptions,
        status: statusCode ?? 200,
        header: req.headers,
        data: dataBody,
        log: logMessage,
        timeRequest: timeRequest);

    onRequest?.call(request);

    // return the response
    return Response(
        status: ok,
        message: message ?? response.statusMessage,
        data: dataBody,
        body: responseData,
        request: request);
  }
}
