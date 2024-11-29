// ignore_for_file: avoid_print

import 'dart:io';

import 'package:yaml/yaml.dart';

void main(List<String> args) {
  // Read pubspec.yaml to get api_path
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('Error: pubspec.yaml not found.');
    return;
  }

  final pubspecContent = pubspec.readAsStringSync();
  final yamlMap = loadYaml(pubspecContent);

  final value = args[0].trim();

  if (value == '-v' || value == '--version') {
    final version = yamlMap['version'];

    print('fetchly: $version');
  }
}
