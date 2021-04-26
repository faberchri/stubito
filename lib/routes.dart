
import 'package:flutter/widgets.dart';
import 'package:tour_log/screens/home/home.dart';
import 'package:tour_log/screens/selected/selected.dart';
import 'package:tour_log/screens/tourdetail/tourdetail.dart';

import 'models/tour.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  TourOverview.routeName: (BuildContext context) => TourOverview(),
  //NewTour.routeName: (BuildContext context) => NewTour(tourModel: TourModel()),
  //'/new': (BuildContext context) => NewTour(),
  TourDetail.routeName: (BuildContext context) => TourDetail(),
};