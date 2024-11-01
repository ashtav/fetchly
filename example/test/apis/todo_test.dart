import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../lib/app/data/apis/api.dart';


class MyHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  final todoApi = TodoApi();
  
  group('TodoApi', () {
    test('Get data', () async {
      // final response = await todoApi.getTodos();
      // ApiTest.check('todo_test.json', response);
    });
  });
}
  