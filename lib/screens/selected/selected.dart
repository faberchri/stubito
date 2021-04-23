import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:tour_log/models/WordPairSelection.dart';
import 'package:tour_log/screens/home/components/randomwords.dart';

class SelectedPage extends StatelessWidget {

  static const routeName = '/selected';

  @override
  Widget build(BuildContext context) {
    var selectionModel = context.watch<WordPairSelectionModel>();

    final tiles = selectionModel.getSortedStrings()
        .map((e) {
          return ListTile(title: Text(
              e,
              style: Theme.of(context).textTheme.headline4)
          );
        });

    final dividedTiles = ListTile.divideTiles(tiles: tiles, context: context)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: ListView(children: dividedTiles),
    );
  }

}

