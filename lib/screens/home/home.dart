import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:tour_log/screens/tour_detail/tour_detail.dart';

class TourOverview extends StatelessWidget {

  static const routeName = '/';

  void navigateToDetail(BuildContext context) {
    Navigator.pushNamed(context, TourDetail.routeName);
  }

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
                  .map((e) => ListTile(
                  title: Text(e.key.toString()),
                  onTap: () {
                    tourListModel.selectTour(e.key);
                    navigateToDetail(context);
                  })
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

