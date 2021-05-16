import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/item_spec.dart';
import 'package:tour_log/routes.dart';
import 'package:tour_log/screens/item_overview/item_overview.dart';
import 'package:tour_log/theme/style.dart';

import 'models/item_list_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => ItemListModel(TodoItemSpec()))
        ],
        child: MaterialApp(
          title: 'Tour Log',
          theme: appTheme(),
          initialRoute: ItemOverview.routeName,
          routes: routes,
          navigatorObservers: [routeObserver],
        ));
  }
}
