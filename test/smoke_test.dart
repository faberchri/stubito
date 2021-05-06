import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/main.dart';

import 'util/finders.dart';
import 'util/helpers.dart';

void main() {
  group('Smoke tests', () {
    testWidgets('Add, edit, remove item', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      // add first item
      await tester.tap(addButtonFinder());
      await pumpForNavigation(tester);

      // enter some text to first item
      final someTextOne = 'abcd';
      await tester.enterText(find.byType(TextField).first, someTextOne);

      // navigate back to overview
      await tester.tap(backButtonFinder());
      await pumpForNavigation(tester);

      // check if item is present in overview
      expect(listTileFinder(someTextOne), findsOneWidget);

      // add second item
      await tester.tap(addButtonFinder());
      await pumpForNavigation(tester);

      // enter some text to second item
      final someTextTwoOrig = 'efgh';
      await tester.enterText(find.byType(TextField).first, someTextTwoOrig);

      // navigate back to overview
      await tester.tap(backButtonFinder());
      await pumpForNavigation(tester, millisecs: 100);

      // check that first and second item are present in overview
      expect(listTileFinder(someTextOne), findsOneWidget);
      expect(listTileFinder(someTextTwoOrig), findsOneWidget);

      // navigate to second item
      await tester.tap(listTileFinder(someTextTwoOrig));
      await pumpForNavigation(tester);

      // edit second item
      final someTextTwoNew = ' xyz';
      final someTextTwoEdited = someTextTwoOrig + someTextTwoNew;
      await tester.enterText(find.byType(TextField).first, someTextTwoEdited);

      // navigate back to overview
      await tester.tap(backButtonFinder());
      await pumpForNavigation(tester);

      // check that first and edited second item are present in overview
      expect(listTileFinder(someTextOne), findsOneWidget);
      expect(listTileFinder(someTextTwoEdited), findsOneWidget);

      // delete first item
      await tester.drag(listTileFinder(someTextOne), Offset(-500.0, 0.0));
      await tester.pump(Duration(milliseconds: 500));
      await tester.tap(find.widgetWithIcon(IconSlideAction, Icons.delete));
      await tester.pump();
      await tester.pump(Duration(milliseconds: 700));

      // check that first item is missing and edited second item is present in overview
      expect(listTileFinder(someTextOne), findsNothing);
      expect(listTileFinder(someTextTwoEdited), findsOneWidget);
    });
  });
}
