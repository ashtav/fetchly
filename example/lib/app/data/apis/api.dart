library api;

import 'package:fetchly/fetchly.dart';

part 'product.dart';
part 'todo.dart';
part 'user.dart';

class Api {
  ProductApi product = ProductApi();
  TodoApi todo = TodoApi();
  UserApi user = UserApi();
}

mixin class Apis {
  Api api = Api();
}
    