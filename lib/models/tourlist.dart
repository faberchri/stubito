import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_log/models/tour.dart';

class TourListModel extends ChangeNotifier {

  final _toursByKey = Map<TourKey, List<TourModel>>();
  TourKey? _selected;

  TourModel newTour() {
    final newModel = TourModel();
    this._toursByKey[newModel.key] = [newModel];

    //print(_tours_by_key.length);
    this._selected = newModel.key;
    notifyListeners();
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
      notifyListeners();
    }
  }

  void updateTour(TourModel newModel) {
    this._toursByKey.update(newModel.key,
            (l) {l.add(newModel); return l;},
            ifAbsent: () => [newModel]
    );
    notifyListeners();
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
    return _toursByKey.values.map((e) => e.last).toList();
  }

}