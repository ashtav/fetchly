import 'dart:io';

import 'package:fetchly/fetchly.dart';
import 'package:flutter_test/flutter_test.dart';

class Http extends HttpOverrides {}

String token = '';

class ApiTest {
  static T init<T>(T api) {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = Http();

    Fetchly.init(baseUrl: 'https://dummyjson.com/');
    Fetchly.setToken(token);
    return api;
  }
}
