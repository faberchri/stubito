import 'package:flutter/widgets.dart';
import 'package:tour_log/screens/item_detail/item_detail.dart';
import 'package:tour_log/screens/item_overview/item_overview.dart';

final RouteObserver routeObserver = RouteObserver();

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  ItemOverview.routeName: (BuildContext context) => ItemOverview(),
  ItemDetail.routeName: (BuildContext context) => ItemDetail(),
};

void navigateToDetail(BuildContext context) {
  Navigator.pushNamed(context, ItemDetail.routeName);
}
