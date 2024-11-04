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

  // Get api_path value from fetchly in pubspec.yaml
  final fetchlyConfig = yamlMap['fetchly'] as YamlMap?;
  final defaultPath = fetchlyConfig?['api_path'] ?? 'app/data/apis';
  final dirPath = 'lib/$defaultPath';

  final dir = Directory(dirPath);

  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
    print('Directory $dirPath deleted successfully.');
  } else {
    print('Directory $dirPath does not exist.');
  }
}
