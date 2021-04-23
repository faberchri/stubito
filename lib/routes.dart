
import 'package:flutter/widgets.dart';
import 'package:tour_log/screens/home/home.dart';
import 'package:tour_log/screens/selected/selected.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  MyHomePage.routeName: (BuildContext context) => MyHomePage(title: 'Deine Touren'),
  SelectedPage.routeName: (BuildContext context) => SelectedPage()
};