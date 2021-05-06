import 'package:flutter_test/flutter_test.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/tour_list.dart';

void main() {
  group('TourListModel unit tests', () {
    test('New list is empty', () {
      final l = TourListModelWithNotificationCount();
      expect(l.allTours(), isEmpty);
      expect(l.notificationCount, 0);
    });

    test('Model contains one after newTour() call', () {
      final l = TourListModelWithNotificationCount();
      final m = l.newTour();
      expect(l.allTours(), containsAllInOrder([m]));
      expect(l.notificationCount, 1);
    });

    test('Model is selected after newTour() call', () {
      final l = TourListModelWithNotificationCount();
      final m = l.newTour();
      expect(l.getSelectedOrNewTour(), m);
      expect(l.notificationCount, 1);
    });

    test('New model is created if nothing is selected', () {
      final l = TourListModelWithNotificationCount();
      final m = l.getSelectedOrNewTour();
      expect(l.allTours(), containsAllInOrder([m]));
      expect(l.notificationCount, 1);
    });

    test('Selected is returned', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      final m2 = l.newTour();
      l.selectTour(m1.key);
      final m3 = l.getSelectedOrNewTour();
      expect(l.allTours(), containsAllInOrder([m2, m1]));
      expect(m1, m3);
      expect(l.notificationCount, 3);
    });

    test('No notification on selecting already selected', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      l.selectTour(m1.key);
      expect(l.notificationCount, 1);
    });

    test('No selection if unknown', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      l.selectTour(TourModel().key);
      expect(l.notificationCount, 1);
      expect(l.getSelectedOrNewTour(), m1);
    });

    test('No selection after deselection', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      l.deselectTour();
      expect(l.notificationCount, 2);
      expect(l.getSelectedOrNewTour(), isNot(m1));
    });

    test('No notification for deselection if nothing selected', () {
      final l = TourListModelWithNotificationCount();
      l.newTour();
      l.deselectTour();
      l.deselectTour();
      expect(l.notificationCount, 2);
    });

    test('Update adds model if unknown and not default', () {
      final l = TourListModelWithNotificationCount();
      final m1 = TourModel(title: 'bla');
      l.updateTour(m1);
      expect(l.allTours(), containsAllInOrder([m1]));
      expect(l.notificationCount, 1);
    });

    test('Update does not adds model if unknown and default', () {
      final l = TourListModelWithNotificationCount();
      final m1 = TourModel();
      l.updateTour(m1);
      expect(l.allTours(), isEmpty);
      expect(l.notificationCount, 0);
    });

    test('Update works', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      final m2 = l.newTour();
      expect(l.allTours(), containsAllInOrder([m2, m1]));
      final m1Mod = m1.copy(title: 'hfbg');
      l.updateTour(m1Mod);
      expect(l.allTours(), containsAllInOrder([m2, m1Mod]));
      expect(l.notificationCount, 3);
    });

    test('Update does not notify if model unchanged', () {
      final l = TourListModelWithNotificationCount();
      final m = l.newTour();
      expect(l.allTours(), containsAllInOrder([m]));
      final title = 'hfbg';
      final mMod1 = m.copy(title: title);
      l.updateTour(mMod1);
      expect(l.allTours(), containsAllInOrder([mMod1]));
      l.updateTour(mMod1.copy(title: title));
      expect(l.allTours(), containsAllInOrder([mMod1]));
      expect(l.notificationCount, 2);
    });

    test('Update does not change selection', () {
      final l = TourListModelWithNotificationCount();
      final m = l.newTour();
      expect(l.getSelectedOrNewTour(), m);
      l.updateTour(TourModel(title: 'bla'));
      expect(l.getSelectedOrNewTour(), m);
      expect(l.notificationCount, 2);
    });

    test('Delete works', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      final m2 = l.newTour();
      expect(l.allTours(), containsAllInOrder([m2, m1]));
      l.deleteTour(m1.key);
      expect(l.allTours(), containsAllInOrder([m2]));
      expect(l.notificationCount, 3);
    });

    test('Delete deselects if model was selected', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      expect(l.getSelectedOrNewTour(), m1);
      l.deleteTour(m1.key);
      expect(l.notificationCount, 2);
      expect(l.getSelectedOrNewTour(), isNot(m1));
    });

    test('Delete does not notify if model unknown', () {
      final l = TourListModelWithNotificationCount();
      l.deleteTour(TourKey());
      expect(l.notificationCount, 0);
    });

    test('Delete does notify only once if selected is deleted', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      expect(l.notificationCount, 1);
      expect(l.getSelectedOrNewTour(), m1);
      l.deleteTour(m1.key);
      expect(l.notificationCount, 2);
    });

    test('Remove empty models works', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      final m2 = l.newTour().copy(title: 'ceve');
      final m3 = l.newTour();
      l.updateTour(m2);
      expect(l.allTours(), containsAllInOrder([m3, m2, m1]));
      expect(l.notificationCount, 4);
      l.removeEmptyTours();
      expect(l.allTours(), containsAllInOrder([m2]));
      expect(l.notificationCount, 5);
    });

    test('Remove empty does not notify if none removed', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour().copy(title: 'ff');
      l.updateTour(m1);
      final m2 = l.newTour().copy(title: 'ceve');
      l.updateTour(m2);
      expect(l.allTours(), containsAllInOrder([m2, m1]));
      expect(l.notificationCount, 4);
      l.removeEmptyTours();
      expect(l.allTours(), containsAllInOrder([m2, m1]));
      expect(l.notificationCount, 4);
    });

    test('Remove empty does deselect if empty selected', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      expect(l.getSelectedOrNewTour(), m1);
      expect(l.notificationCount, 1);
      l.removeEmptyTours();
      expect(l.notificationCount, 2);
      expect(l.allTours(), isEmpty);
      expect(l.getSelectedOrNewTour(), isNot(m1));
    });

    test('Models are returned in reversed insertion order', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      final m2 = l.newTour();
      final m3 = l.newTour();
      expect(l.allTours(), containsAllInOrder([m3, m2, m1]));
    });

    test('Querying models does not notify', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      final m2 = l.newTour();
      expect(l.notificationCount, 2);
      expect(l.allTours(), containsAllInOrder([m2, m1]));
      expect(l.notificationCount, 2);
    });

    test('Querying models does not change selection', () {
      final l = TourListModelWithNotificationCount();
      final m1 = l.newTour();
      final m2 = l.newTour();
      expect(l.getSelectedOrNewTour(), m2);
      expect(l.allTours(), containsAllInOrder([m2, m1]));
      expect(l.getSelectedOrNewTour(), m2);
    });
  });
}

class TourListModelWithNotificationCount extends TourListModel {
  var notificationCount = 0;

  @override
  void notifyListeners() {
    notificationCount++;
    super.notifyListeners();
  }
}
