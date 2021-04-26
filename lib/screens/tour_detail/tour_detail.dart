import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/tour_list.dart';

class TourDetail extends StatelessWidget {

  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    final tourListModel = context.watch<TourListModel>();
    var model = tourListModel.getSelectedOrNewTour();
    return Scaffold(
      appBar: AppBar(
        title: Text('Tour Details'),
      ),
      body: ListView(children: [Text(model.title), Text(model.key.toString())]),
    );
  }
}
