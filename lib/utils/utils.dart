import 'package:intl/intl.dart';

class Utils {
  static String dateFormat(DateTime date,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(date);
  }
}

/// Custom print function for development use only.
/// Uses `assert` to ensure the print statement only executes in debug mode.
/// In release mode, this function does nothing.
void devPrint(Object? object) {
  assert(() {
    // ignore: avoid_print
    print(object);
    return true;
  }());
}
