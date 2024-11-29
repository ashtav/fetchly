// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fetchly/utils/strings.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a name for the API class.');
    return;
  }

  // Baca nama package dari pubspec.yaml
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('Error: pubspec.yaml not found.');
    return;
  }

  final pubspecContent = pubspec.readAsStringSync();
  final yamlMap = loadYaml(pubspecContent);
  final packageName = yamlMap['name'] as String;

  final value = args[0].trim();
  final fileName = toSnakeCase(value);
  final className = toPascalCase(fileName);

  const defaultPath = 'apis';
  final filePath = value.contains('/') ? value : '$defaultPath/$fileName';

  final testFile = File('test/${filePath}_test.dart');
  final testContent = '''
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:$packageName/app/data/apis/api.dart';

class Http extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = Http();

  final ${toCamelCase(fileName)}Api = ${className}Api();

  group('${className}Api', () {
    test('Describe your test here', () async {
      
    });
  });
}
  ''';

  testFile.createSync(recursive: true);
  testFile.writeAsStringSync(testContent);
  print(
      'Test file ${fileName.split('/').last}_test.dart created successfully at test/${filePath}_test.dart.');
}
