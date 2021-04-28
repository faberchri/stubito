import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/routes.dart';
import 'package:tour_log/theme/style.dart';

import 'models/tour_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
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
