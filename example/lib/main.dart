import 'package:fetchly/fetchly.dart';
import 'package:flutter/material.dart';

import 'screens/todo_view.dart';

void main() {
  UseFetchly(
          baseUrl: 'https://dummyjson.com/',
          onRequest: (status, data) {
            // listen request
          },
          onError: (e, s) {
            // listen error
          })
      .init();

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
