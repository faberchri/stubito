import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/item.dart';
import 'package:tour_log/models/item_spec.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/item_list.dart';

final todoItemSpec = TodoItemSpec();

Future<void> pumpForNavigation(WidgetTester tester,
    {int millisecs = 50}) async {
  return tester
      .pump()
      .then((value) => tester.pump(Duration(milliseconds: millisecs)));
}

ItemListModel createTourListModelWithEntries(List<String> entries) {
  final tourListModel = ItemListModel(todoItemSpec);

  entries.forEach((ts) {
    var m = ItemModel(todoItemSpec);
    final newTitle = m.fields.firstWhere((element) => element.spec.label == 'Titel').copy(ts);
    m = m.copy(newTitle);
    tourListModel.updateItem(m);
  });
  return tourListModel;
}
