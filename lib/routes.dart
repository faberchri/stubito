import 'package:flutter/widgets.dart';
import 'package:tour_log/screens/home/home.dart';
import 'package:tour_log/screens/tour_detail/tour_detail.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  TourOverview.routeName: (BuildContext context) => TourOverview(),
  TourDetail.routeName: (BuildContext context) => TourDetail(),
};
