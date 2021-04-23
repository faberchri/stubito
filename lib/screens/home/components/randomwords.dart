import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:tour_log/models/WordPairSelection.dart';
import 'package:provider/provider.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  // final _saved = <WordPair>{};


  Widget _buildSuggestions(WordPairSelectionModel selectionModel) {
    return ListView.builder(

        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings
          // in the ListView,minus the divider widgets.
          final int index = i ~/ 2;
          // If you've reached the end of the available word
          // pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the
            // suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(selectionModel, _suggestions[index]);
        });
  }

  // void toggleWordPair(WordPair pair) {
  //   setState(() {
  //     if (!_saved.remove(pair)) {
  //       _saved.add(pair);
  //     }
  //   });
  // }

  Widget _buildRow(WordPairSelectionModel selectionModel, WordPair pair) {
    final selected = selectionModel.isSelected(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: Theme.of(context).textTheme.headline4,
      ),
      trailing: Icon(
        selected ? Icons.favorite : Icons.favorite_border,
        color: selected ? Colors.red : null,
      ),
      onTap: () => selectionModel.toggle(pair)
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectionModel = context.watch<WordPairSelectionModel>();
    return _buildSuggestions(selectionModel);
  }
}
