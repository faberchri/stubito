import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:tour_log/screens/tour_overview/components/list_entry.dart';

import '../../routes.dart';

class TourOverview extends StatelessWidget {

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {

    final tourListModel = context.watch<TourListModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Deine Touren'),
      ),
      body: Center(
          child: ListView(
              children: tourListModel
                  .allTours()
                  .map((e) => TourOverviewListEntry(e, tourListModel)
              ).toList()
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tourListModel.newTour();
          navigateToDetail(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

