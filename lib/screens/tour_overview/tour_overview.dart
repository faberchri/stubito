import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:tour_log/screens/tour_overview/components/list_entry.dart';
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

    //final tourListModel = context.watch<TourListModel>();

    //tourListModel.removeEmptyTours();


    return Scaffold(
      appBar: AppBar(
        title: Text('Deine Touren'),
      ),
      body: Center(
          // child: AnimatedList(
          //     itemBuilder: ,
          //     children: tourListModel
          //         .allTours()
          //         .map((e) => Dismissible(
          //         key: ValueKey(e.key.id),
          //         onDismissed: (direction) {
          //           tourListModel.deleteTour(e.key);
          //         },
          //         background: Container(color: Colors.red),
          //         child: TourOverviewListEntry(e, tourListModel))
          //     ).toList()
          // )
        child: TourList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TourListModel>().newTour();
          //tourListModel.newTour();
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
    final x = ModalRoute.of(context);
    routeObserver.subscribe(this, x!);
    //routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    print('didPopNext Overview');
    context.read<TourListModel>().removeEmptyTours();
  }
}

