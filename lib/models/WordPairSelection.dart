
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';

class WordPairSelectionModel extends ChangeNotifier {

  final _selected = <WordPair>{};

  void toggle(WordPair pair) {
    if (!_selected.remove(pair)) {
      _selected.add(pair);
    }
    notifyListeners();
  }

  bool isSelected(WordPair pair) {
    return _selected.contains(pair);
  }

  List<String> getSortedStrings() {
    final list = _selected.map((w) => w.asPascalCase).toList();
    list.sort();
    return list;
  }

}