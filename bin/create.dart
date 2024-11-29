// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fetchly/utils/strings.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('Error: pubspec.yaml not found.');
    return;
  }

  // check if arguments is available
  if (args.isEmpty) {
    print('Please provide a name for the API class.');
    return;
  }

  final pubspecContent = pubspec.readAsStringSync();
  final yamlMap = loadYaml(pubspecContent);

  final value = args[0].trim();
  final fileName = toSnakeCase(value); // Convert to snake_case
  final className = toPascalCase(fileName); // Convert to PascalCase

  final fetchlyConfig = yamlMap['fetchly'] as YamlMap?;
  final defaultPath = fetchlyConfig?['api_path'] ?? 'app/data/apis';
  final filePath = value.contains('/') ? value : '$defaultPath/$fileName';

  // Ensure the lib directory exists
  final file = File('lib/$filePath.dart');

  // Ignore if the file name is 'api'
  if (fileName == 'api') {
    return print(
        'Cannot create the file named api.dart, please use another name.');
  }

  if (file.existsSync()) {
    if (args.length == 1) {
      print(
          'File ${fileName.split('/').last} already exists at lib/$filePath.dart.');
      return;
    } else {
      if (args[1] != '-f') {
        print('Use -f to force create a new file.');
      }
    }
  }

  // preparing file content
  final content = '''
part of 'api.dart';

class ${className}Api extends Fetchly {
  Future<Response> getData([Map<String, dynamic>? query]) async => get('path', query);
}''';

  file.createSync(recursive: true);
  file.writeAsStringSync(content);
  print(
      'File ${fileName.split('/').last} created successfully at lib/$filePath.dart.');

  // CREATE SECOND FILES -------------------------------------------------------------

  // Check if api.dart exists in app/data/apis
  final apiFile = File('lib/$defaultPath/api.dart');

  if (!apiFile.existsSync()) {
    // If api.dart does not exist, create it with the specified content
    final apiContent = '''
library api;

import 'package:fetchly/fetchly.dart';

part '$fileName.dart';

class Api extends ApiServices {
  ${className}Api ${toCamelCase(fileName)} = ${className}Api();
}

mixin class Apis {
  Api api = Api();
}
    ''';

    apiFile.createSync(recursive: true);
    apiFile.writeAsStringSync(apiContent);
    print('api.dart created successfully in $defaultPath.');
  } else {
    // If api.dart exists, update its content
    final existingContent = apiFile.readAsStringSync();

    // Check if 'import fetchly' is missing and add it
    bool hasImport =
        existingContent.contains("import 'package:fetchly/fetchly.dart';");

    /// Generate part and class content for the new API
    final partLine = "part '$fileName.dart';";
    final apiInstanceLine =
        "  ${className}Api ${toCamelCase(fileName)} = ${className}Api();";

    // Check if the part line already exists
    if (!existingContent.contains(partLine)) {
      // Check if we need to add 'import fetchly' or not
      final updatedContent = hasImport
          // Add part line after 'import fetchly' if it exists, without extra newlines
          ? existingContent.replaceFirst(
              "import 'package:fetchly/fetchly.dart';\n",
              "import 'package:fetchly/fetchly.dart';\n\n$partLine")
          // Add 'import fetchly' and part line if not found, without extra newlines
          : existingContent
              .replaceFirst('library api;',
                  "library api;\n\nimport 'package:fetchly/fetchly.dart';\n\n$partLine")
              .replaceFirst('$partLine\n', partLine);

      // Add the new API instance in the class Api
      final updatedApiInstanceContent = updatedContent.replaceFirst(
        'class Api {',
        'class Api {\n$apiInstanceLine',
      );

      // Write the updated content back to the api.dart file
      apiFile.writeAsStringSync(updatedApiInstanceContent);
      print('api.dart updated with ${className}Api in $defaultPath.');
    }
  }
}
