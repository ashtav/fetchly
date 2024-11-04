library api;

import 'package:fetchly/fetchly.dart';

part 'todo.dart';

class Api {
  TodoApi todo = TodoApi();
}

mixin class Apis {
  Api api = Api();
}
