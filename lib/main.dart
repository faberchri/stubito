import 'package:flutter/material.dart';
import 'package:tour_log/models/WordPairSelection.dart';
import 'package:tour_log/routes.dart';
import 'package:tour_log/screens/home/home.dart';
import 'package:tour_log/theme/style.dart';
import 'package:provider/provider.dart';

import 'models/tourlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => WordPairSelectionModel()),
          ChangeNotifierProvider(create: (context) => TourListModel())
        ],
        child: MaterialApp(
          title: 'Tour Log',
          theme: appTheme(),
          initialRoute: '/',
          routes: routes,
        )
    );
  }
}




