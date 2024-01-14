import 'package:fetchly/fetchly.dart';

class TodoApi extends Fetchly {
  Future<ResHandler> getTodos() async => await get('todos');
  Future<ResHandler> login(Map<String, dynamic> data) async =>
      await post('auth/login', data);

  // custom request
  Future<ResHandler> custom() async {
    return await fetch('GET', 'todos', onReceiveProgress: (a, b) {
      // print('$a $b');
    });
  }
}
