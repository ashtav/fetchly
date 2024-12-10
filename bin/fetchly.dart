// ignore_for_file: avoid_print

import 'dart:io';

import 'package:yaml/yaml.dart';
import 'utils.dart';

void main(List<String> args) {
  // Read pubspec.yaml to get api_path
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('Error: pubspec.yaml not found.');
    return;
  }

  final pubspecContent = pubspec.readAsStringSync();
  final yamlMap = loadYaml(pubspecContent);

  if (args.isEmpty) {
    String filename = 'f.bat';
    String content = '''
@REM This file was generated by Fetchly, do not change it!
@REM Use: .\\f <command>

@echo off
dart run fetchly:%*
''';

    // write the content to the .bat file
    File file = File(filename);
    file.writeAsStringSync(content);

    Print.info(
        'Now you can use fetchly in short way, type: .\\f create <filename>');
    return;
  }

  final value = args[0].trim();

  if (value == '-v' || value == '--version') {
    final version = yamlMap['version'];

    Print.info('fetchly: $version');
  }
}
