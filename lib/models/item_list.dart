import 'package:flutter/foundation.dart';
import 'package:tour_log/models/item_spec.dart';
import 'package:tour_log/models/tour.dart';

import 'item.dart';

class ItemListModel extends ChangeNotifier {
  final ItemSpec itemSpec;
  final _itemsByKey = Map<ItemKey, List<ItemModel>>();
  ItemKey? _selected;

  ItemListModel(this.itemSpec);

  ItemModel newItem() {
    final newModel = ItemModel(this.itemSpec);
    print(newModel);
    this._itemsByKey[newModel.itemKey] = [newModel];
    this._selected = newModel.itemKey;
    _notify();
    return newModel;
  }

  ItemModel getSelectedOrNewItem() {
    if (_selected != null) {
      return this._itemsByKey[_selected]!.last;
    }
    return newItem();
  }

  void selectItem(ItemKey key) {
    if (_itemsByKey.containsKey(key) && this._selected != key) {
      this._selected = key;
      _notify();
    }
  }

  void deselectItem() {
    if (_selected != null) {
      _selected = null;
      _notify();
    }
  }

  void updateItem(ItemModel newModel) {
    final prevModels = this._itemsByKey[newModel.itemKey];
    if (prevModels != null && prevModels.last != newModel) {
      prevModels.add(newModel);
      _notify();
      return;
    }
    if (prevModels == null && !newModel.hasAllDefaultValues()) {
      this._itemsByKey[newModel.itemKey] = [newModel];
      _notify();
    }
  }

  void deleteItem(ItemKey key) {
    final removedFromMap = this._itemsByKey.remove(key) != null;
    var unselected = false;
    if (key == _selected) {
      _selected = null;
      unselected = true;
    }
    if (removedFromMap || unselected) {
      _notify();
    }
  }

  void removeEmptyItems() {
    var keysOfEmptyItems = _itemsByKey.values
        .map((e) => e.last)
        .where((element) => element.hasAllDefaultValues())
        .map((e) => e.itemKey)
        .toSet();
    _itemsByKey.removeWhere((key, value) => keysOfEmptyItems.contains(key));
    if (keysOfEmptyItems.contains(_selected)) {
      _selected = null;
    }
    if (keysOfEmptyItems.isNotEmpty) {
      _notify();
    }
  }

  List<ItemModel> allItems() {
    return _itemsByKey.values.map((e) => e.last).toList().reversed.toList();
  }

  void _notify() {
    print('selected: ${_selected?.id} | ${allItems().map((e) => e.itemKey.id)}');
    notifyListeners();
  }
}
