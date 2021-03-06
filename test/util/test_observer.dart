import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

typedef OnObservation = void Function(
    Route<dynamic>? route, Route<dynamic>? previousRoute);

void isNullRoute(Route<dynamic>? route) {
  expect(route, isNull);
}

void isPageRoute(String routeName, Route<dynamic>? route) {
  expect(route is PageRoute && route.settings.name == routeName, isTrue);
}

class TestObserver extends NavigatorObserver {
  OnObservation? onPushed;
  OnObservation? onPopped;
  OnObservation? onRemoved;
  OnObservation? onReplaced;
  OnObservation? onStartUserGesture;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onPushed?.call(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onPopped?.call(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRemoved?.call(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? oldRoute, Route<dynamic>? newRoute}) {
    onReplaced?.call(newRoute, oldRoute);
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    onStartUserGesture?.call(route, previousRoute);
  }
}
