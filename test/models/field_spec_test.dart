import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/item_spec.dart';

import '../util/helpers.dart';

void main() {
  group('FieldSpec unit tests', () {
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