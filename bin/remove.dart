// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fetchly/utils/strings.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  // Read the pubspec.yaml file
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('Error: pubspec.yaml not found.');
    return;
  }

  final pubspecContent = pubspec.readAsStringSync();
  final yamlMap = loadYaml(pubspecContent);

  // Get the api_path value from the fetchly configuration in pubspec.yaml
  final fetchlyConfig = yamlMap['fetchly'] as YamlMap?;
  final defaultPath = fetchlyConfig?['api_path'] ?? 'app/data/apis';

  if (args.isEmpty) {
    print('Please provide a name for the API class to remove.');
    return;
  }

  final value = args[0].trim();
  final fileName = toSnakeCase(value); // Convert to snake_case
  final filePath = 'lib/$defaultPath/$fileName.dart';

  // Ignore if the file name is 'api'
  if (fileName == 'api') {
    print('Cannot remove the file named api.dart.');
    return;
  }

  final file = File(filePath);

  // Check if the file exists
  if (!file.existsSync()) {
    print('File $filePath does not exist.');
    return;
  }

  // Delete the file
  file.deleteSync();

  // Check if api.dart exists in the configured path
  final apiFile = File('lib/$defaultPath/api.dart');
  if (apiFile.existsSync()) {
    final existingContent = apiFile.readAsStringSync();

    // Generate the part line and class instance line to be removed
    final partLine = "part '$fileName.dart';";
    final apiInstanceLine =
        "  ${toPascalCase(fileName)}Api ${toCamelCase(fileName)} = ${toPascalCase(fileName)}Api();\n";

    // Remove the part line and class instance from the Api class
    final updatedContent =
        existingContent.replaceAll(RegExp(RegExp.escape(partLine) + r'\n'), '').replaceAll(apiInstanceLine, '');

    // Write the updated content back to api.dart
    apiFile.writeAsStringSync(updatedContent.trim());
    print('File $filePath deleted successfully.');
  }
}
