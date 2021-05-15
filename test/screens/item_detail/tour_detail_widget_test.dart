import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/item_list.dart';
import 'package:tour_log/screens/item_detail/item_detail.dart';

import '../../util/helpers.dart';
import '../../util/test_app.dart';

Widget createTourDetailScreen({
  List<NavigatorObserver> navObservers = const [],
  ItemListModel? tourListModel,
}) {
  if (tourListModel == null) {
    tourListModel = ItemListModel(todoItemSpec);
    tourListModel.newItem();
  }
  return createTestApp(ItemDetail.routeName,
      navObservers: navObservers, itemListModel: tourListModel);
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

    testWidgets('Has an input field for due date', (WidgetTester tester) async {
      await tester.pumpWidget(createTourDetailScreen());
      expect(find.text('Bis wann?'), findsOneWidget);
      expect(find.widgetWithIcon(ElevatedButton, Icons.calendar_today),
          findsOneWidget);
    });
  });
}
