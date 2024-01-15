/// Defines the types of print behavior for debugging or logging purposes.
///
/// This enum is used to specify how messages should be handled during runtime.
enum PrintType {
  /// Use this to print messages to the console.
  print,

  /// Use this to log messages, potentially to a file or logging system.
  log,

  /// Use this to disable printing or logging.
  none
}
