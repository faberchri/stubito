import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/item.dart';
import 'package:tour_log/models/item_list.dart';

import '../util/helpers.dart';

void main() {
  group('TourListModel unit tests', () {
    test('New list is empty', () {
      final l = ItemListModelWithNotificationCount();
      expect(l.allItems(), isEmpty);
      expect(l.notificationCount, 0);
    });

    test('Model contains one after newTour() call', () {
      final l = ItemListModelWithNotificationCount();
      final m = l.newItem();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m]));
      expect(l.notificationCount, 1);
    });

    test('Model is selected after newTour() call', () {
      final l = ItemListModelWithNotificationCount();
      final m = l.newItem();
      expect(l.getSelectedOrNewItem(), m);
      expect(l.notificationCount, 1);
    });

    test('New model is created if nothing is selected', () {
      final l = ItemListModelWithNotificationCount();
      final m = l.getSelectedOrNewItem();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m]));
      expect(l.notificationCount, 1);
    });

    test('Selected is returned', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      final m2 = l.newItem();
      l.selectItem(m1.itemKey);
      final m3 = l.getSelectedOrNewItem();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2, m1]));
      expect(m1, m3);
      expect(l.notificationCount, 3);
    });

    test('No notification on selecting already selected', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      l.selectItem(m1.itemKey);
      expect(l.notificationCount, 1);
    });

    test('No selection if unknown', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      l.selectItem(newEmptyItem().itemKey);
      expect(l.notificationCount, 1);
      expect(l.getSelectedOrNewItem(), m1);
    });

    test('No selection after deselection', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      l.deselectItem();
      expect(l.notificationCount, 2);
      expect(l.getSelectedOrNewItem(), isNot(m1));
    });

    test('No notification for deselection if nothing selected', () {
      final l = ItemListModelWithNotificationCount();
      l.newItem();
      l.deselectItem();
      l.deselectItem();
      expect(l.notificationCount, 2);
    });

    test('Update adds model if unknown and not default', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = newItemWithTitle('bla');
      l.updateItem(m1);
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m1]));
      expect(l.notificationCount, 1);
    });

    test('Update does not adds model if unknown and default', () {
      final l = ItemListModelWithNotificationCount();
      l.updateItem(newEmptyItem());
      expect(l.allItems(), isEmpty);
      expect(l.notificationCount, 0);
    });

    test('Update works', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      final m2 = l.newItem();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2, m1]));
      final m1Mod = setTitle(m1, 'hfbg');
      l.updateItem(m1Mod);
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2, m1Mod]));
      expect(l.notificationCount, 3);
    });

    test('Update does not notify if model unchanged', () {
      final l = ItemListModelWithNotificationCount();
      final m = l.newItem();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m]));
      final title = 'hfbg';
      final mMod1 = setTitle(m, title);
      l.updateItem(mMod1);
      expect(l.allItems(), containsAllInOrder(<ItemModel>[mMod1]));
      l.updateItem(setTitle(mMod1, title));
      expect(l.allItems(), containsAllInOrder(<ItemModel>[mMod1]));
      expect(l.notificationCount, 2);
    });

    test('Update does not change selection', () {
      final l = ItemListModelWithNotificationCount();
      final m = l.newItem();
      expect(l.getSelectedOrNewItem(), m);
      l.updateItem(newItemWithTitle('bla'));
      expect(l.getSelectedOrNewItem(), m);
      expect(l.notificationCount, 2);
    });

    test('Delete works', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      final m2 = l.newItem();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2, m1]));
      l.deleteItem(m1.itemKey);
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2]));
      expect(l.notificationCount, 3);
    });

    test('Delete deselects if model was selected', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      expect(l.getSelectedOrNewItem(), m1);
      l.deleteItem(m1.itemKey);
      expect(l.notificationCount, 2);
      expect(l.getSelectedOrNewItem(), isNot(m1));
    });

    test('Delete does not notify if model unknown', () {
      final l = ItemListModelWithNotificationCount();
      l.deleteItem(ItemKey());
      expect(l.notificationCount, 0);
    });

    test('Delete does notify only once if selected is deleted', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      expect(l.notificationCount, 1);
      expect(l.getSelectedOrNewItem(), m1);
      l.deleteItem(m1.itemKey);
      expect(l.notificationCount, 2);
    });

    test('Remove empty models works', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      final m2 = setTitle(l.newItem(), 'ceve');
      final m3 = l.newItem();
      l.updateItem(m2);
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m3, m2, m1]));
      expect(l.notificationCount, 4);
      l.removeEmptyItems();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2]));
      expect(l.notificationCount, 5);
    });

    test('Remove empty does not notify if none removed', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = setTitle(l.newItem(), 'ff');
      l.updateItem(m1);
      final m2 = setTitle(l.newItem(), 'ceve');
      l.updateItem(m2);
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2, m1]));
      expect(l.notificationCount, 4);
      l.removeEmptyItems();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2, m1]));
      expect(l.notificationCount, 4);
    });

    test('Remove empty does deselect if empty selected', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      expect(l.getSelectedOrNewItem(), m1);
      expect(l.notificationCount, 1);
      l.removeEmptyItems();
      expect(l.notificationCount, 2);
      expect(l.allItems(), isEmpty);
      expect(l.getSelectedOrNewItem(), isNot(m1));
    });

    test('Models are returned in reversed insertion order', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      final m2 = l.newItem();
      final m3 = l.newItem();
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m3, m2, m1]));
    });

    test('Querying models does not notify', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      final m2 = l.newItem();
      expect(l.notificationCount, 2);
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2, m1]));
      expect(l.notificationCount, 2);
    });

    test('Querying models does not change selection', () {
      final l = ItemListModelWithNotificationCount();
      final m1 = l.newItem();
      final m2 = l.newItem();
      expect(l.getSelectedOrNewItem(), m2);
      expect(l.allItems(), containsAllInOrder(<ItemModel>[m2, m1]));
      expect(l.getSelectedOrNewItem(), m2);
    });
  });
}

ItemModel newEmptyItem() {
  return ItemModel(todoItemSpec);
}

ItemModel newItemWithTitle(String title) {
  final m = newEmptyItem();
  final newTitle = m.fields
      .where((element) => element.spec.label == 'Titel')
      .first
      .copy(title);
  return m.copy(newTitle);
}

ItemModel setTitle(ItemModel prevModel, String title) {
  final newTitle = prevModel.fields
      .where((element) => element.spec.label == 'Titel')
      .first
      .copy(title);
  return prevModel.copy(newTitle);
}

class ItemListModelWithNotificationCount extends ItemListModel {
  var notificationCount = 0;

  ItemListModelWithNotificationCount() : super(todoItemSpec);

  @override
  void notifyListeners() {
    notificationCount++;
    super.notifyListeners();
  }
}
