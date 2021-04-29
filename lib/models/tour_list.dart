import 'package:flutter/foundation.dart';
import 'package:tour_log/models/tour.dart';

class TourListModel extends ChangeNotifier {
  final _toursByKey = Map<TourKey, List<TourModel>>();
  TourKey? _selected;

  TourModel newTour() {
    final newModel = TourModel();
    print(newModel);
    this._toursByKey[newModel.key] = [newModel];
    this._selected = newModel.key;
    _notify();
    return newModel;
  }

  TourModel getSelectedOrNewTour() {
    if (_selected != null) {
      return this._toursByKey[_selected]!.last;
    }
    return newTour();
  }

  void selectTour(TourKey key) {
    if (_toursByKey.containsKey(key)) {
      this._selected = key;
      _notify();
    }
  }

  void deselectTour() {
    if (_selected != null) {
      _selected = null;
      _notify();
    }
  }

  void updateTour(TourModel newModel) {
    final prevModels = this._toursByKey[newModel.key];
    if (prevModels != null && prevModels.last != newModel) {
      prevModels.add(newModel);
      _notify();
      return;
    }
    if (prevModels == null && !newModel.hasAllDefaultValues()) {
      this._toursByKey[newModel.key] = [newModel];
      _notify();
    }
  }

  void deleteTour(TourKey key) {
    final removedFromMap = this._toursByKey.remove(key) != null;
    var unselected = false;
    if (key == _selected) {
      _selected = null;
      unselected = true;
    }
    if (removedFromMap || unselected) {
      _notify();
    }
  }

  void removeEmptyTours() {
    var keysOfEmptyTours = _toursByKey.values
        .map((e) => e.last)
        .where((element) => element.hasAllDefaultValues())
        .map((e) => e.key)
        .toSet();
    _toursByKey.removeWhere((key, value) => keysOfEmptyTours.contains(key));
    if (keysOfEmptyTours.contains(_selected)) {
      _selected = null;
    }
    if (keysOfEmptyTours.isNotEmpty) {
      _notify();
    }
  }

  List<TourModel> allTours() {
    return _toursByKey.values.map((e) => e.last).toList().reversed.toList();
  }

  void _notify() {
    print('selected: ${_selected?.id} | ${allTours().map((e) => e.key.id)}');
    notifyListeners();
  }
}
