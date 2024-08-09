import 'package:fetchly/fetchly.dart';

class TodoApi extends Fetchly {
  Future<Response> getTodos() async => await get('todos');
  Future<Response> login(Map<String, dynamic> data) async =>
      await post('auth/login', data);

  // custom request
  Future<Response> custom() async {
    return await fetch('GET', 'todos', onReceiveProgress: (a, b) {
      // print('$a $b');
    });
  }

  Future<Response> test() async {
    return await get('/');
  }
}