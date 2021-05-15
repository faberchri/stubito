import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/item_list.dart';
import 'package:tour_log/routes.dart';
import 'package:tour_log/screens/item_detail/item_detail.dart';
import 'package:tour_log/screens/item_overview/item_overview.dart';

import '../../util/finders.dart';
import '../../util/helpers.dart';
import '../../util/test_app.dart';
import '../../util/test_observer.dart';

Widget createItemOverviewScreen({
  List<NavigatorObserver> navObservers = const [],
  ItemListModel? itemListModel,
}) =>
    createTestApp(ItemOverview.routeName,
        navObservers: navObservers, itemListModel: itemListModel);

void main() {
  group('ItemOverview widget tests', () {
    testWidgets('Has add button', (WidgetTester tester) async {
      await tester.pumpWidget(createItemOverviewScreen());

      expect(addButtonFinder(), findsOneWidget);
    });

    testWidgets('Has title in header', (WidgetTester tester) async {
      await tester.pumpWidget(createItemOverviewScreen());
      final appBarTitleFinder = find.widgetWithText(AppBar, 'Deine Touren');

      expect(appBarTitleFinder, findsOneWidget);
    });

    testWidgets('Tap on add button triggers navigation to detail',
        (WidgetTester tester) async {
      var navigationPushed = false;
      final testObserver = TestObserver()
        ..onPushed = (Route<dynamic>? route, Route<dynamic>? previousRoute) {
          // Pushes the initial route.
          isNullRoute(previousRoute);
          isPageRoute(ItemOverview.routeName, route);
          navigationPushed = true;
        };

      await tester
          .pumpWidget(createItemOverviewScreen(navObservers: [testObserver]));
      await tester.pump();

      expect(navigationPushed, isTrue);
      navigationPushed = false;

      testObserver.onPushed =
          (Route<dynamic>? route, Route<dynamic>? previousRoute) {
        isPageRoute(ItemOverview.routeName, previousRoute);
        isPageRoute(ItemDetail.routeName, route);
        navigationPushed = true;
      };

      await tester.tap(addButtonFinder());
      await pumpForNavigation(tester);

      expect(navigationPushed, isTrue);
      expect(find.byType(ItemDetail), findsOneWidget);
    });

    testWidgets('Tap on item triggers navigation to detail',
        (WidgetTester tester) async {
      var navigationPushed = false;
      final testObserver = TestObserver()
        ..onPushed = (Route<dynamic>? route, Route<dynamic>? previousRoute) {
          // Pushes the initial route.
          isNullRoute(previousRoute);
          isPageRoute(ItemOverview.routeName, route);
          navigationPushed = true;
        };

      final testStrings = [
        'my test item 1',
        'my test item 2',
        'my test item 3'
      ];
      final itemListModel = createItemListModelWithEntries(testStrings);

      await tester.pumpWidget(createItemOverviewScreen(
        navObservers: [testObserver],
        itemListModel: itemListModel,
      ));
      await tester.pumpAndSettle();

      for (final testStringIndex in [1, 0, 2]) {
        // validate navigation took place and all items are on overview screen
        expect(navigationPushed, isTrue);
        testStrings
            .map((ts) => listTileFinder(ts))
            .forEach((finder) => expect(finder, findsOneWidget));

        // prepare for navigation to detail screen
        navigationPushed = false;
        testObserver.onPushed =
            (Route<dynamic>? route, Route<dynamic>? previousRoute) {
          isPageRoute(ItemOverview.routeName, previousRoute);
          isPageRoute(ItemDetail.routeName, route);
          navigationPushed = true;
        };
        final testString = testStrings[testStringIndex];

        // navigate to detail
        await tester.tap(listTileFinder(testString));
        await pumpForNavigation(tester);

        // validate detail screen
        expect(backButtonFinder(), findsOneWidget);
        expect(navigationPushed, isTrue);
        expect(find.byType(ItemDetail), findsOneWidget);
        expect(find.widgetWithText(TextField, testString), findsOneWidget);

        // navigate back to overview
        testObserver.onPushed =
            (Route<dynamic>? route, Route<dynamic>? previousRoute) {
          isPageRoute(ItemDetail.routeName, previousRoute);
          isPageRoute(ItemOverview.routeName, route);
          navigationPushed = true;
        };
        await tester.tap(backButtonFinder());
        await tester.pumpAndSettle(); // make sure everything is settled
      }
    });

    testWidgets('Tap on add button creates entry', (WidgetTester tester) async {
      await tester.pumpWidget(createItemOverviewScreen());

      final newItemEntryFinder = listTileFinder('Neues Todo');
      expect(newItemEntryFinder, findsNothing);

      await tester.tap(addButtonFinder());
      await tester.pump();

      expect(newItemEntryFinder, findsOneWidget);
    });

    testWidgets('Empty item is removed', (WidgetTester tester) async {
      await tester
          .pumpWidget(createItemOverviewScreen(navObservers: [routeObserver]));
      final newItemEntryFinder = listTileFinder('Neues Todo');

      // check no items present
      expect(newItemEntryFinder, findsNothing);

      // add item
      await tester.tap(addButtonFinder());
      await tester.pump();
      expect(newItemEntryFinder, findsOneWidget);

      // make navigation complete
      await tester.pump(Duration(milliseconds: 50));

      // check we're on detail page
      expect(backButtonFinder(), findsOneWidget);
      expect(find.byType(ItemDetail), findsOneWidget);

      // navigate back
      await tester.tap(backButtonFinder());
      await tester.pump();

      // empty item is still present after return from detail
      expect(newItemEntryFinder, findsOneWidget);

      // wait for empty item to be removed
      await tester.pump(Duration(milliseconds: 1000));
      expect(newItemEntryFinder, findsNothing);
    });

    testWidgets('Non-empty item is not removed', (WidgetTester tester) async {
      await tester
          .pumpWidget(createItemOverviewScreen(navObservers: [routeObserver]));

      final someText = 'abcd';
      final newEntryFinder = listTileFinder(someText);

      // check no items present
      expect(newEntryFinder, findsNothing);

      // add item and navigate to detail
      await tester.tap(addButtonFinder());
      await pumpForNavigation(tester);

      // check we're on detail page
      final textFieldsFinder = find.byType(TextField);
      expect(backButtonFinder(), findsOneWidget);
      expect(textFieldsFinder, findsWidgets);

      // edit item
      await tester.enterText(textFieldsFinder.first, someText);

      // navigate back
      await tester.tap(backButtonFinder());
      await tester.pumpAndSettle(); // make sure everything is settled

      // check item is in list
      expect(newEntryFinder, findsOneWidget);
    });

    testWidgets('Items can be deleted', (WidgetTester tester) async {
      final testStrings = [
        'my test item 1',
        'my test item 2',
        'my test item 3'
      ];
      final itemListModel = createItemListModelWithEntries(testStrings);

      await tester.pumpWidget(createItemOverviewScreen(
        itemListModel: itemListModel,
      ));

      final deletionOrder = [0, 2, 1];
      final deleted = <String>{};
      for (final testStringIndex in deletionOrder) {
        testStrings
            .where((ts) => !deleted.contains(ts))
            .map((ts) => listTileFinder(ts))
            .forEach((finder) => expect(finder, findsOneWidget));

        final testString = testStrings[testStringIndex];
        final toDeleteItemFinder = listTileFinder(testString);
        final toDeleteButtonFinder =
            find.widgetWithIcon(IconSlideAction, Icons.delete);

        // check item is present and delete button is not present
        expect(toDeleteItemFinder, findsOneWidget);
        expect(toDeleteButtonFinder, findsNothing);

        // show delete button
        await tester.drag(toDeleteItemFinder, Offset(-500.0, 0.0));
        await tester.pump(Duration(milliseconds: 500));

        // check delete button is present
        expect(toDeleteButtonFinder, findsOneWidget);

        // tap delete button
        await tester.tap(toDeleteButtonFinder);
        await tester.pump();
        await tester.pump(Duration(milliseconds: 700));

        // check item was deleted
        expect(toDeleteItemFinder, findsNothing);

        deleted.add(testString);
      }

      // check all items were deleted
      expect(find.byType(ListTile), findsNothing);
    });
  });
}
