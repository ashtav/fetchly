import 'package:intl/intl.dart';

class Utils {
  static String dateFormat(DateTime date,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(date);
  }
}
