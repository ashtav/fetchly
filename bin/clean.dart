// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  const dirPath = 'lib/app/data/apis';
  final dir = Directory(dirPath);

  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
    print('Directory $dirPath deleted successfully.');
  }
}
