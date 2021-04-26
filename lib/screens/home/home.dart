import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:tour_log/models/tourlist.dart';
import 'package:tour_log/screens/home/components/randomwords.dart';
import 'package:tour_log/screens/selected/selected.dart';
import 'package:tour_log/screens/tourdetail/tourdetail.dart';
import 'package:provider/provider.dart';


class TourOverview extends StatelessWidget {

  static const routeName = '/';

  void _pushSaved(BuildContext context) {

  }

  // void addTour(BuildContext context) {
  //   Navigator.pushNamed(context, NewTour.routeName);
  // }

  @override
  Widget build(BuildContext context) {

    final tourListModel = context.watch<TourListModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Deine Touren'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: () => _pushSaved(context)),
        ],
      ),
      body: Center(
          child: ListView(
            children: tourListModel.allTours()
                .map((e) => ListTile(
                  title: Text(e.key.toString()),
                  onTap: () {
                    tourListModel.selectTour(e.key);
                    Navigator.pushNamed(context, TourDetail.routeName);
                  })).toList()
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //addTour(context);

          //var tourListModel = context.read<TourListModel>();
          //tourListModel.newTour();
          //tourListModel.removeEmptyTours();
          //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewTour()));
          //Navigator.pushNamed(context, '/new');
          tourListModel.newTour();
          Navigator.pushNamed(context, TourDetail.routeName);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
