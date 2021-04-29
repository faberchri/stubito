import 'package:flutter/material.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:provider/provider.dart';


import '../../../routes.dart';

class TourOverviewListEntry extends StatelessWidget {

  final TourModel tourModel;

  TourOverviewListEntry(this.tourModel);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(this.tourModel.title.isNotEmpty ? this.tourModel.title : 'Neue Tour'),
        subtitle: Text(this.tourModel.remarks.isNotEmpty ? this.tourModel.remarks : 'kR'),
        onTap: () {
          context.read<TourListModel>().selectTour(tourModel.key);
          navigateToDetail(context);
        });
  }
}
