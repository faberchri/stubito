import 'package:flutter/widgets.dart';
import 'package:tour_log/screens/tour_detail/tour_detail.dart';
import 'package:tour_log/screens/tour_overview/tour_overview.dart';

final RouteObserver routeObserver = RouteObserver();

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  TourOverview.routeName: (BuildContext context) => TourOverview(),
  TourDetail.routeName: (BuildContext context) => TourDetail(),
};

void navigateToDetail(BuildContext context) {
  Navigator.pushNamed(context, TourDetail.routeName);
}
