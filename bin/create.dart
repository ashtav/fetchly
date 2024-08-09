// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fetchly/utils/strings.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a name for the API class.');
    return;
  }

  final value = args[0].trim();
  final fileName = toSnakeCase(value); // Convert to snake_case
  final className = toPascalCase(fileName); // Convert to PascalCase

  const defaultPath = 'app/data/apis';
  final filePath = value.contains('/') ? value : '$defaultPath/$fileName';

  final content = '''
part of 'api.dart';

class ${className}Api extends Fetchly {

}
  ''';

  // Ensure the lib directory exists
  final file = File('lib/$filePath.dart');

  // Ignore if the file name is 'api'
  if (fileName == 'api') {
    print('Cannot create the file named api.dart, please use another name.');
    return;
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

  file.createSync(recursive: true);
  file.writeAsStringSync(content);
  print(
      'File ${fileName.split('/').last} created successfully at lib/$filePath.dart.');

  // Check if api.dart exists in app/data/apis
  final apiFile = File('lib/$defaultPath/api.dart');
  if (!apiFile.existsSync()) {
    // If api.dart does not exist, create it with the specified content
    final apiContent = '''
library api;

import 'package:fetchly/fetchly.dart';

part '$fileName.dart';

class Api {
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

    // Generate part and class content for the new API
    final partLine = "part '$fileName.dart';";
    final apiInstanceLine =
        "  ${className}Api ${toCamelCase(fileName)} = ${className}Api();";

    // Check if the part line already exists
    if (!existingContent.contains(partLine)) {
      final updatedContent = existingContent.replaceFirst(
        'part \'',
        '$partLine\npart \'',
      );

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
