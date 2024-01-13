// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:example/data/todo_api.dart';
import 'package:fetchly/fetchly.dart';
import 'package:flutter/material.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  TodoApi api = TodoApi();

  List<dynamic> todos = [];
  bool isLoading = true;

  Future getTodos() async {
    try {
      ResHandler res = await api.getTodos();
      todos = res.body?['todos'] ?? [];
    } catch (e, s) {
      print('Error: $e, StackTrace: $s');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future login() async {
    try {
      log('-- loading');
      ResHandler res =
          await api.login({'username': 'kminchelle', 'password': '0lelplR'});

      log(res.toMap().toString());
      log('------ ${res.message}');
    } catch (e, s) {
      print('Error: $e, StackTrace: $s');
    }
  }

  Future error500() async {
    String url = 'http://httpstat.us/500';
    ResHandler res = await api.get(url);
    print(res.message);
  }

  @override
  void initState() {
    getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        actions: [
          IconButton(
              onPressed: () {
                error500();
              },
              icon: const Icon(Icons.error)),
          IconButton(
              onPressed: () {
                login();
              },
              icon: const Icon(Icons.account_circle)),
          IconButton(
              onPressed: () {
                api.cancel('todos');
              },
              icon: const Icon(Icons.cancel))
        ],
      ),
      body: isLoading
          ? const Center(child: Text('Loading...'))
          : todos.isEmpty
              ? const Center(child: Text('Oops, no data found'))
              : ListView(
                  children: List.generate(
                      todos.length,
                      (i) => Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color:
                                  i % 2 == 0 ? Colors.grey[100] : Colors.white,
                            ),
                            child: Text(todos[i]['todo']),
                          )),
                ),
    );
  }
}
