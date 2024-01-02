import 'package:fetchly/utils/log.dart';

class RequestHandler {
  static onRequest(String path, int status, dynamic data) {
    // here we can check response from server and do something
    // for example:

    if (![200, 201].contains(status)) {
      // do something, such as send error to developer

      List<int> ignore = [401, 422];
      if (!ignore.contains(status)) {
        // ignore this status code
        logg('error: $status, $data');
      }
    }
  }

  static onError(Object error, StackTrace s) {
    logg('Error: $error, StackTrace: $s');
  }
}
