// ignore_for_file: avoid_print

class Print {
  static error(String message) {
    const red = '\x1B[31m'; // ANSI code for red
    const reset = '\x1B[0m'; // ANSI code to reset to default color
    print('$red[!] $message$reset');
  }

  static info(dynamic message) {
    print('\x1B[32m[¡] $message\x1B[0m');
  }
}

String camelize(String input) => input
    .split('_')
    .map((word) => word[0].toUpperCase() + word.substring(1))
    .join('');
