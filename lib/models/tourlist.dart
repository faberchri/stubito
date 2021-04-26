import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_log/models/tour.dart';

class TourListModel extends ChangeNotifier {

  final _tours_by_key = Map<TourKey, List<TourModel>>();

  TourModel newTour() {
    final newModel = TourModel();
    this._tours_by_key[newModel.key] = [newModel];
    notifyListeners();
    print(_tours_by_key.length);
    return newModel;
  }

  void updateTour(TourModel newModel) {
    this._tours_by_key.update(newModel.key,
            (l) {l.add(newModel); return l;},
            ifAbsent: () => [newModel]
    );
    notifyListeners();
  }

  void deleteTour(TourKey key) {
    this._tours_by_key.remove(key);
    notifyListeners();
  }

  void removeEmptyTours() {
    var keysOfEmptyTours = _tours_by_key.values
        .map((e) => e.last)
        .where((element) => element.hasAllDefaultValues())
        .map((e) => e.key).toSet();
    _tours_by_key.removeWhere((key, value) => keysOfEmptyTours.contains(key));
    notifyListeners();
  }

  List<TourModel> allTours() {
    return _tours_by_key.values.map((e) => e.last).toList();
  }

}