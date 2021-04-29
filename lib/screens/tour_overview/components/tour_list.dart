import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/tour_list.dart';
import 'package:tour_log/screens/tour_overview/components/list_entry.dart';

class TourList extends StatefulWidget {
  @override
  _TourListState createState() {
    return _TourListState();
  }
}

class _TourListState extends State<TourList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<TourModel> _tourModels = [];

  @override
  void initState() {
    super.initState();
    _tourModels = context.read<TourListModel>().allTours();
  }

  @override
  Widget build(BuildContext context) {
    final currentTourModels = context.watch<TourListModel>().allTours();

    final animatedList = AnimatedList(
      key: _listKey,
      initialItemCount: currentTourModels.length,
      itemBuilder: (context, index, animation) =>
          _buildItem(context, currentTourModels[index], animation),
    );

    final prevTourKeys = _tourModels.map((e) => e.key).toSet();
    final currentTourKeys = currentTourModels.map((e) => e.key).toSet();
    _removeMissingTours(prevTourKeys, currentTourKeys);
    _addNewTours(currentTourModels, prevTourKeys, currentTourKeys);

    setState(() {
      _tourModels = currentTourModels;
    });
    return animatedList;
  }

  void _removeMissingTours(
      Set<TourKey> prevTourKeys, Set<TourKey> currentTourKeys) {
    final removedKeys = prevTourKeys.difference(currentTourKeys);
    _tourModels.asMap().forEach((index, tourModel) {
      if (removedKeys.contains(tourModel.key)) {
        _listKey.currentState!.removeItem(
          index,
          (context, animation) =>
              _buildItem(context, tourModel, animation, x: 1),
          duration: Duration(milliseconds: 500),
        );
      }
    });
  }

  void _addNewTours(List<TourModel> currentTourModels,
      Set<TourKey> prevTourKeys, Set<TourKey> currentTourKeys) {
    final addedKeys = currentTourKeys.difference(prevTourKeys);
    currentTourModels.asMap().forEach((index, tourModel) {
      if (addedKeys.contains(tourModel.key)) {
        _listKey.currentState!.insertItem(index);
      }
    });
  }

  Widget _buildItem(
      BuildContext context, TourModel tourModel, Animation<double> animation,
      {double x = -1}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SlideTransition(
          position: Tween<Offset>(begin: Offset(x, 0), end: Offset.zero)
              .animate(animation),
          child: TourOverviewListEntry(tourModel)),
    );
  }
}
