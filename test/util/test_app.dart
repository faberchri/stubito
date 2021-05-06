import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:tour_log/routes.dart';

Widget createTestApp(
  String initialRoute, {
  List<NavigatorObserver> navObservers = const [],
  TourListModel? tourListModel,
}) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => tourListModel ?? TourListModel()),
      ],
      child: MaterialApp(
        navigatorObservers: navObservers,
        routes: routes,
        initialRoute: initialRoute,
      ),
    );
