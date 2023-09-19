import 'package:fetchly/fetchly.dart';

class TodoApi extends Fetchly {
  Future<ResHandler> getTodos() async => await get('todos');
  Future<ResHandler> login(Map<String, dynamic> data) async =>
      await post('https://api.igsa.pw/api/auth/login', data);
}
