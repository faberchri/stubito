import 'package:flutter_test/flutter_test.dart';

import '../util/helpers.dart';

void main() {
  group('ItemSpec unit tests', () {
    test('Todo item has correct plural name', () {
      final item = todoItemSpec;
      expect(item.itemNamePlural, 'Todos');
    });

    test('Todo item has two field specs', () {
      final item = todoItemSpec;
      expect(item.fields, hasLength(2));
    });
  });
}
