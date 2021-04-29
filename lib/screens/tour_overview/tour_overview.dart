import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:tour_log/screens/tour_overview/components/tour_list.dart';

import '../../routes.dart';

class TourOverview extends StatefulWidget {
  static const routeName = '/';

  @override
  State createState() {
    return _TourOverviewState();
  }
}

class _TourOverviewState extends State<TourOverview> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deine Touren'),
      ),
      body: Center(
        child: TourList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TourListModel>().newTour();
          navigateToDetail(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    final tourList = context.read<TourListModel>();
    tourList.removeEmptyTours();
    tourList.deselectTour();
  }
}
