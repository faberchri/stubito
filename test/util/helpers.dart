import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/tour_list.dart';

Future<void> pumpForNavigation(WidgetTester tester,
    {int millisecs = 50}) async {
  return tester
      .pump()
      .then((value) => tester.pump(Duration(milliseconds: millisecs)));
}

TourListModel createTourListModelWithEntries(List<String> entries) {
  final tourListModel = TourListModel();
  entries.forEach((ts) => tourListModel.updateTour(TourModel(title: ts)));
  return tourListModel;
}
