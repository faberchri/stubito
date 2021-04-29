import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:tour_log/models/tour.dart';

class TourListModel extends ChangeNotifier {

  final _toursByKey = Map<TourKey, List<TourModel>>();
  TourKey? _selected;

  TourModel newTour() {
    final newModel = TourModel();
    this._toursByKey[newModel.key] = [newModel];
    this._selected = newModel.key;
    notifyListeners();
    return newModel;
  }

  TourModel getSelectedOrNewTour() {
    if (_selected != null) {
      return this._toursByKey[_selected]!.last;
    }
    return TourModel();
    //return newTour();
  }

  void selectTour(TourKey key) {
    if (_toursByKey.containsKey(key)) {
      this._selected = key;
      notifyListeners();
    }
  }

  void deselectTour() {
    if (_selected != null) {
      _selected = null;
      notifyListeners();
    }
  }

  void updateTour(TourModel newModel) {

    final prevModels = this._toursByKey[newModel.key];
    if (prevModels != null && prevModels.last != newModel) {
      prevModels.add(newModel);
      notifyListeners();
      return;
    }
    if (prevModels == null && !newModel.hasAllDefaultValues()) {
      this._toursByKey[newModel.key] = [ newModel ];
      notifyListeners();
    }

    // this._toursByKey.update(newModel.key,
    //         (l) {
    //   if (l.last != newModel) {
    //     l.add(newModel);
    //     notifyListeners();
    //   }
    //   return l;
    //   },
    //     ifAbsent: () {
    //   print('toursByKey 1: $_toursByKey'); return [newModel];
    //     }
    // );
    // print('toursByKey 2:' + _toursByKey.values.map((e) => '${e.last.title}: ${e.length}').toList().toString());

  }

  void deleteTour(TourKey key) {
    final removedFromMap = this._toursByKey.remove(key) != null;
    var unselected = false;
    if (key == _selected) {
      _selected = null;
      unselected = true;
    }
    if (removedFromMap || unselected) {
      notifyListeners();
    }
  }

  void removeEmptyTours() {
    var keysOfEmptyTours = _toursByKey.values
        .map((e) => e.last)
        .where((element) => element.hasAllDefaultValues())
        .map((e) => e.key).toSet();
    _toursByKey.removeWhere((key, value) => keysOfEmptyTours.contains(key));
    if (keysOfEmptyTours.contains(_selected)) {
      _selected = null;
    }
    if (keysOfEmptyTours.isNotEmpty) {
      notifyListeners();
    }
  }

  List<TourModel> allTours() {
    return _toursByKey.values.map((e) => e.last).toList().reversed.toList();
  }
}
