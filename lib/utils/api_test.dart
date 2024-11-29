// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:fetchly/fetchly.dart';
import 'package:flutter/services.dart';

/// A utility class for API testing and validation against a JSON model file.
class ApiTest {
  /// Checks the structure of the response against a local JSON model file.
  ///
  /// This method verifies if the response structure matches the expected
  /// structure defined in a JSON file located at [jsonPath]. It checks for
  /// missing keys and data type mismatches in the response.
  ///
  /// - Parameters:
  ///   - [jsonPath]: The file path of the JSON model.
  ///   - [response]: The HTTP response to validate.
  ///   - [deep]: If `true`, checks every element in arrays for a more thorough
  ///     validation. Default is `false`.
  static Future<void> check(String jsonPath, Response response,
      {bool deep = false}) async {
    try {
      // Load JSON model file as a string
      final jsonStr = await rootBundle.loadString('assets/models/$jsonPath');
      final Map<String, dynamic> jsonData = json.decode(jsonStr);

      // Initialize lists to store any detected issues
      List<String> missingKeys = [];
      List<String> updatedDataType = [];
      bool isValidFormat = true;

      // Decode the response body as JSON
      final data =
          response.body is String ? json.decode(response.body) : response.body;

      // Define basic request info for logging
      String path = response.request?.path ?? '/';
      String method = response.request?.method ?? 'GET';
      String timeRequest = response.request?.timeRequest ?? '0';
      String message = '';

      /// Recursively checks for key existence and data types between model and response.
      ///
      /// This function compares each key in the model against the response
      /// data to ensure the response has matching keys and correct data types.
      /// It updates [missingKeys] and [updatedDataType] lists accordingly.
      ///
      /// - Parameters:
      ///   - [model]: The JSON model data to compare.
      ///   - [responseData]: The actual response data to check.
      ///   - [parentKey]: A string representing the current nested path.
      void checkNested(Map<String, dynamic> model,
          Map<String, dynamic> responseData, String parentKey,
          {bool deep = false}) {
        model.forEach((key, value) {
          final fullKey = parentKey.isEmpty ? key : '$parentKey.$key';

          // Check if the key exists in the response data
          if (!responseData.containsKey(key)) {
            missingKeys.add(fullKey);
          } else {
            final responseValue = responseData[key];

            // Recursively check nested maps
            if (value is Map && responseValue is Map) {
              checkNested(value.cast<String, dynamic>(),
                  responseValue.cast<String, dynamic>(), fullKey,
                  deep: deep);
            } else if (value is List && responseValue is List) {
              if (deep) {
                // If deep is true, validate each array element individually
                for (int i = 0; i < responseValue.length; i++) {
                  final modelElement = value.isNotEmpty ? value.first : null;
                  final responseElement = responseValue[i];

                  if (modelElement is Map && responseElement is Map) {
                    checkNested(
                      modelElement.cast<String, dynamic>(),
                      responseElement.cast<String, dynamic>(),
                      '$fullKey[$i]',
                      deep: deep,
                    );
                  } else if (modelElement != null &&
                      modelElement.runtimeType != responseElement.runtimeType) {
                    updatedDataType.add(
                        "Key '$fullKey[$i]' should be ${modelElement.runtimeType}, but received ${responseElement.runtimeType}");
                  }
                }
              } else if (value.isNotEmpty && responseValue.isNotEmpty) {
                // Check only the first element if deep is false
                final modelElement = value.first;
                final responseElement = responseValue.first;

                if (modelElement is Map && responseElement is Map) {
                  checkNested(
                    modelElement.cast<String, dynamic>(),
                    responseElement.cast<String, dynamic>(),
                    '$fullKey[0]',
                    deep: deep,
                  );
                } else if (modelElement.runtimeType !=
                    responseElement.runtimeType) {
                  updatedDataType.add(
                      "Key '$fullKey[0]' should be ${modelElement.runtimeType}, but received ${responseElement.runtimeType}");
                }
              }
            } else if (responseValue.runtimeType != value.runtimeType) {
              updatedDataType.add(
                  "Key '$fullKey' should be ${value.runtimeType}, but received ${responseValue.runtimeType}");
            }
          }
        });
      }

      // Start recursive check if data is a Map
      if (data is Map<String, dynamic>) {
        checkNested(jsonData, data, '', deep: deep);
      } else if (data is List && data.isNotEmpty) {
        final firstItem = data.first;
        if (firstItem is Map<String, dynamic>) {
          checkNested(jsonData, firstItem, '', deep: deep);
        } else {
          message +=
              "⚠️  List does not contain a Map. Cannot perform key checks.\n";
        }
      } else if (data is List && data.isEmpty) {
        message += "⚠️  Data is an empty List. No validation performed.\n";
      } else {
        message +=
            "⚠️  Unknown data format. Expected Map or List. Received '${data.runtimeType}' \n";
        isValidFormat = false;
      }

      // Compile message based on missing keys and type mismatches
      if (isValidFormat) {
        if (missingKeys.isNotEmpty || updatedDataType.isNotEmpty) {
          message += '❗️ JSON structure mismatch in backend response.\n\n';

          if (missingKeys.isNotEmpty) {
            message += '❌ Missing keys:\n- ${missingKeys.join('\n- ')}\n\n';
          }

          if (updatedDataType.isNotEmpty) {
            message += '⚠️  Type changes:\n${updatedDataType.join('\n')}\n';
          }

          message +=
              'This indicates that backend changes may impact the app.\n';
        } else {
          message +=
              '✅ JSON structure matches expected model. No issues found.\n';
        }
      }

      // Color-coded console output for easy reading
      final pen = AnsiPen()
        ..white()
        ..cyan(bg: true);

      print(pen('📍 Path: $path | $method | $timeRequest'));
      print(message);
    } catch (e, s) {
      print('error: $e, $s');
    }
  }
}
