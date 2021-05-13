import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/item_list.dart';
import 'package:tour_log/models/item_spec.dart';
import 'package:tour_log/routes.dart';

import 'helpers.dart';

Widget createTestApp(
  String initialRoute, {
  List<NavigatorObserver> navObservers = const [],
  ItemListModel? itemListModel,
}) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => itemListModel ?? ItemListModel(todoItemSpec)),
      ],
      child: MaterialApp(
        navigatorObservers: navObservers,
        routes: routes,
        initialRoute: initialRoute,
      ),
    );
