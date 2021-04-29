import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/theme/style.dart';

import '../../../routes.dart';

class TourOverviewListEntry extends StatelessWidget {
  final TourModel tourModel;

  TourOverviewListEntry(this.tourModel);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        key: ValueKey(tourModel.key),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: appTheme().errorColor,
            icon: Icons.delete,
            onTap: () {
              context.read<TourListModel>().deleteTour(tourModel.key);
            },
          ),
        ],
        child: ListTile(
            title: Text(this.tourModel.title.isNotEmpty
                ? this.tourModel.title
                : 'Neue Tour'),
            subtitle: Text(this.tourModel.remarks.isNotEmpty
                ? this.tourModel.remarks
                : this.tourModel.key.id),
            onTap: () {
              context.read<TourListModel>().selectTour(tourModel.key);
              navigateToDetail(context);
            }));
  }
}
