import 'package:fetchly/fetchly.dart';
import 'package:flutter/material.dart';

import 'screens/todo_view.dart';

void main() {

  Fetchly.instance.init(
    baseUrl: 'https://dummyjson.com/',
    onRequest: (status, data) {},
  ).setHeader({'Authorization': 'Bearer token'});

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
