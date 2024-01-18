import 'package:fetchly/fetchly.dart';
import 'package:fetchly/utils/log.dart';

class RequestHandler {
  static onRequest(Request request) {
    int status = request.status;
    dynamic data = request.data;

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
