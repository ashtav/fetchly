// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fetchly/utils/strings.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  // Read pubspec.yaml for configuration
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('Error: pubspec.yaml not found.');
    return;
  }

  final pubspecContent = pubspec.readAsStringSync();
  final yamlMap = loadYaml(pubspecContent);

  // Get model_path from fetchly config in pubspec.yaml
  final fetchlyConfig = yamlMap['fetchly'] as YamlMap?;
  final defaultPath = fetchlyConfig?['model_path'] ?? 'app/data/models';

  // Check if arguments are available
  if (args.isEmpty) {
    print('Invalid command! Try: dart run fetchly:model <model>');
    return;
  }

  final value = args[0].trim();

  // Split value by '/' if exists
  final parts = value.split('/');
  final fileName = '${parts.last}.dart'; // Take the last part as the file name
  final className = toPascalCase(parts.last); // Convert last part to PascalCase

  // Construct the base directory path
  final baseDirectoryPath =
      'lib/$defaultPath/${parts.sublist(0, parts.length - 1).join('/')}';
  final baseDirectory = Directory(baseDirectoryPath);

  // Check if the base directory exists
  if (!baseDirectory.existsSync()) {
    print('Directory $baseDirectoryPath not found!');
    return;
  }

  // Function to recursively search for the file
  void searchFileInDirectory(Directory directory) {
    final entities = directory.listSync(recursive: true);

    for (var entity in entities) {
      if (entity is File && entity.path.endsWith(fileName)) {
        final content = entity.readAsStringSync();

        // Define the code to be added
        final codeToAdd = '''
  
  static List<$className> fromJsonList(List? data) {
    return (data ?? []).map((e) => $className.fromJson(e)).toList();
  }''';

        // Check if the code already exists
        if (!content.contains('static List<$className> fromJsonList')) {
          // Add the new code before the closing bracket
          final updatedContent = content.replaceFirst(
            RegExp(r'}\s*$'), // Replace the last closing bracket
            '$codeToAdd\n}',
          );

          // Write the updated content back to the file
          entity.writeAsStringSync(updatedContent);

          final clickablePath = entity.path.replaceAll(r'\', '/');

          print('fromJsonList has been added to $clickablePath');
        }
        return;
      } else if (entity is Directory && entity.path.endsWith(parts.last)) {
        // If a directory with the last part is found, search inside it
        searchFileInDirectory(entity);
      }
    }
  }

  // Start searching in the base directory
  searchFileInDirectory(baseDirectory);
}
