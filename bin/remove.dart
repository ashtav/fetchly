// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fetchly/utils/strings.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a name for the API class to remove.');
    return;
  }

  final value = args[0].trim();
  final fileName = toSnakeCase(value); // Convert to snake_case
  final filePath = 'lib/app/data/apis/$fileName.dart';

  // Ignore if the file name is 'api'
  if (fileName == 'api') {
    print('Cannot remove the file named api.dart.');
    return;
  }

  final file = File(filePath);

  if (!file.existsSync()) {
    print('File $filePath does not exist.');
    return;
  }

  // Delete the file
  file.deleteSync();

  // Check if api.dart exists in app/data/apis
  final apiFile = File('lib/app/data/apis/api.dart');
  if (apiFile.existsSync()) {
    final existingContent = apiFile.readAsStringSync();

    // Generate part and class content to remove
    final partLine = "part '$fileName.dart';";
    final apiInstanceLine = "  ${toPascalCase(fileName)}Api ${toCamelCase(fileName)} = ${toPascalCase(fileName)}Api();\n";

    // Remove the part line and class instance from Api
    final updatedContent = existingContent
        .replaceAll(RegExp(RegExp.escape(partLine) + r'\n'), '') // Use partLine correctly
        .replaceAll(apiInstanceLine, '');

    // Write the updated content back to the api.dart file
    apiFile.writeAsStringSync(updatedContent.trim());
    print('File $filePath deleted successfully.');
  }
}
