import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/item.dart';
import 'package:tour_log/models/item_list.dart';
import 'package:tour_log/models/item_spec.dart';

final todoItemSpec = TodoItemSpec();

Future<void> pumpForNavigation(WidgetTester tester,
    {int millisecs = 50}) async {
  return tester
      .pump()
      .then((value) => tester.pump(Duration(milliseconds: millisecs)));
}

ItemListModel createItemListModelWithEntries(List<String> entries) {
  final itemListModel = ItemListModel(todoItemSpec);

  entries.forEach((ts) {
    var m = ItemModel(todoItemSpec);
    final newTitle = m.fields
        .firstWhere((element) => element.spec.label == 'Titel')
        .copy(ts);
    m = m.copy(newTitle);
    itemListModel.updateItem(m);
  });
  return itemListModel;
}
