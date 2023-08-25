import 'package:fetchly/fetchly.dart';

class TodoApi extends Fetchly {
  Future<ResHandler> getTodos() async => await get('todos');
}
