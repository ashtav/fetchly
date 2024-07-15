import 'package:example/request_handler.dart';
import 'package:fetchly/fetchly.dart';
import 'package:fetchly/models/config.dart';
import 'package:flutter/material.dart';

import 'screens/todo_view.dart';

void main() {
  Fetchly.init(
      baseUrl: 'https://dummyjson.com/',
      onRequest: RequestHandler.onRequest,
      onError: RequestHandler.onError,
      printType: PrintType.print,
      config: FetchlyConfig(printLimit: 3000, showHeader: true));

  // to set token in header when user logged in
  dio.setToken('token_value');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetchly Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoView(),
    );
  }
}
