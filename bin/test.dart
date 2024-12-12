// ignore_for_file: avoid_print

import 'dart:io';

import 'package:yaml/yaml.dart';

import 'utils.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    Print.error('Please provide a name for the API class.');
    return;
  }

  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    Print.error('Error: pubspec.yaml not found.');
    return;
  }

  final pubspecContent = pubspec.readAsStringSync();
  final yamlMap = loadYaml(pubspecContent);
  final packageName = yamlMap['name'] as String;

  final apiName = args[0];
  final testDir = Directory('test/apis');
  if (!testDir.existsSync()) {
    testDir.createSync(recursive: true);
    print('Created folder: ${testDir.path}');
  }

  final apiFile = File('${testDir.path}/api.dart');
  if (!apiFile.existsSync()) {
    apiFile.writeAsStringSync(_apiFileContent);
    print('Created file: ${apiFile.path}');
  }

  final userTestFile = File('${testDir.path}/${apiName}_test.dart');
  userTestFile
      .writeAsStringSync(_generateUserTestContent(apiName, packageName));
  print('Created file: ${userTestFile.path}');
}

const String _apiFileContent = '''
import 'dart:io';

import 'package:fetchly/fetchly.dart';
import 'package:flutter_test/flutter_test.dart';

class Http extends HttpOverrides {}

String token = '';

class ApiTest {
  static T init<T>(T api) {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = Http();

    Fetchly.init(baseUrl: '');
    Fetchly.setToken(token);
    return api;
  }
}
''';

String _generateUserTestContent(String apiName, String packageName) {
  return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:fetchly/fetchly.dart';
import 'package:$packageName/app/data/apis/api.dart';


import 'api.dart';

void main() {
  final api = ApiTest.init(${camelize(apiName)}Api());

  group('${camelize(apiName)}Api', () {
    test('Check $apiName response match', () async {
      final response = await api.getUser();
      response.check('$apiName.json', deep: true);
    });
  });
}
''';
}
