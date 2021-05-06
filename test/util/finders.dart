import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder addButtonFinder() {
  return find.byIcon(Icons.add);
}

Finder backButtonFinder() {
  return find.byType(BackButton);
}

Finder listTileFinder(String text) {
  return find.widgetWithText(ListTile, text);
}
