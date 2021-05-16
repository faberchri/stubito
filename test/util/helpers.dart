import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/field_model_visitor.dart';
import 'package:tour_log/models/item_list_model.dart';
import 'package:tour_log/models/item_model.dart';
import 'package:tour_log/models/item_spec.dart';

final todoItemSpec = TodoItemSpec();

Future<void> pumpForNavigation(WidgetTester tester,
    {int millisecs = 50}) async {
  return tester
      .pump()
      .then((value) => tester.pump(Duration(milliseconds: millisecs)));
}

ItemModel newEmptyTodoItem() {
  return ItemModel(todoItemSpec);
}

ItemModel newTodoItemWithTitle(String title) {
  return setTodoItemTitle(newEmptyTodoItem(), title);
}

ItemModel setTodoItemTitle(ItemModel model, String title) {
  final newTitleField = model.fields
      .where((element) => element.spec.label == TodoItemSpec.titleFieldLabel)
      .map(mapFieldOrDefaultValue(null, onTextField: (m) => m.copy(title)))
      .first!;
  return model.copy(newTitleField);
}

ItemListModel createItemListModelWithTodoEntries(List<String> entries) {
  final itemListModel = ItemListModel(todoItemSpec);

  entries.forEach((ts) {
    var m = ItemModel(todoItemSpec);
    m = setTodoItemTitle(m, ts);
    itemListModel.updateItem(m);
  });
  return itemListModel;
}
