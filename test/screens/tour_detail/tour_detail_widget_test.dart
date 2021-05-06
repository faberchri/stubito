import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:tour_log/screens/tour_detail/tour_detail.dart';
import 'package:tour_log/screens/tour_overview/components/tour_list.dart';

import '../../util/helpers.dart';
import '../../util/test_app.dart';

Widget createTourDetailScreen({
  List<NavigatorObserver> navObservers = const [],
  TourListModel? tourListModel,
}) {
  if (tourListModel == null) {
    tourListModel = TourListModel();
    tourListModel.newTour();
  }
  return createTestApp(TourDetail.routeName,
        navObservers: navObservers, tourListModel: tourListModel);
}


void main() {
  group('TourDetail widget tests', () {
    testWidgets('Has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(createTourDetailScreen());
      expect(find.widgetWithText(AppBar, 'Tour Details'), findsOneWidget);
    });

    testWidgets('Has an input field for title', (WidgetTester tester) async {
      await tester.pumpWidget(createTourDetailScreen());
      expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    });

    testWidgets('Has an input field for remarks', (WidgetTester tester) async {
      await tester.pumpWidget(createTourDetailScreen());
      expect(find.widgetWithText(TextField, 'Remarks'), findsOneWidget);
    });

  });
}