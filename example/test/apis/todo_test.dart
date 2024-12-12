import 'package:example/app/data/apis/api.dart';
import 'package:fetchly/fetchly.dart';
import 'package:flutter_test/flutter_test.dart';

import 'api.dart';

void main() {
  final api = ApiTest.init(TodoApi());

  group('TodoApi', () {
    test('Check todo response match', () async {
      final response = await api.getTodos();
      response.check('todo.json', deep: true);
    });
  });
}
