import 'package:intl/intl.dart';

/// A utility class providing static methods for common functionalities.
///
/// This class includes methods for various utility operations that can be
/// used throughout the application. It is not meant to be instantiated.
class Utils {
  /// Formats a given [DateTime] object into a string according to the specified format.
  ///
  /// This method utilizes the `DateFormat` class to convert a [DateTime] object
  /// into a formatted string. The default format is 'yyyy-MM-dd HH:mm:ss', but
  /// this can be customized by providing a different format pattern.
  ///
  /// Example usage:
  /// ```dart
  /// DateTime now = DateTime.now();
  /// String formattedDate = Utils.dateFormat(now);
  /// // Outputs in default format, e.g., "2024-01-18 12:34:56"
  ///
  /// String customFormattedDate = Utils.dateFormat(now, format: 'dd-MM-yyyy');
  /// // Outputs in custom format, e.g., "18-01-2024"
  /// ```
  ///
  /// Parameters:
  /// - [date]: The [DateTime] object to be formatted.
  /// - [format]: An optional parameter to specify the desired format pattern.
  ///   Defaults to 'yyyy-MM-dd HH:mm:ss'.
  ///
  /// Returns a string representing the formatted date.
  static String dateFormat(DateTime date,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(date);
  }
}
