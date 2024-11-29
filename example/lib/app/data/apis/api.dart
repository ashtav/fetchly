library api;

import 'package:fetchly/fetchly.dart';

part 'todo.dart';

class Api extends ApiServices {
  TodoApi todo = TodoApi();
}

mixin class Apis {
  Api api = Api();
}
