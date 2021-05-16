import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/item_list_model.dart';
import 'package:tour_log/models/item_model.dart';

import 'list_entry.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() {
    return _ItemListState();
  }
}

class _ItemListState extends State<ItemList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<ItemModel> _itemModels = [];

  @override
  void initState() {
    super.initState();
    _itemModels = context.read<ItemListModel>().allItems();
  }

  @override
  Widget build(BuildContext context) {
    final currentItemModels = context.watch<ItemListModel>().allItems();

    final animatedList = AnimatedList(
      key: _listKey,
      initialItemCount: currentItemModels.length,
      itemBuilder: (context, index, animation) =>
          _buildItem(context, currentItemModels[index], animation),
    );

    final prevItemKeys = _itemModels.map((e) => e.itemKey).toSet();
    final currentItemKeys = currentItemModels.map((e) => e.itemKey).toSet();
    _removeMissingItems(prevItemKeys, currentItemKeys);
    _addNewItems(currentItemModels, prevItemKeys, currentItemKeys);

    setState(() {
      _itemModels = currentItemModels;
    });
    return animatedList;
  }

  void _removeMissingItems(
      Set<ItemKey> prevItemKeys, Set<ItemKey> currentItemKeys) {
    final removedKeys = prevItemKeys.difference(currentItemKeys);
    _itemModels.asMap().forEach((index, itemModel) {
      if (removedKeys.contains(itemModel.itemKey)) {
        _listKey.currentState!.removeItem(
          index,
          (context, animation) =>
              _buildItem(context, itemModel, animation, x: 1),
          duration: Duration(milliseconds: 500),
        );
      }
    });
  }

  void _addNewItems(List<ItemModel> currentItemModels,
      Set<ItemKey> prevItemKeys, Set<ItemKey> currentItemKeys) {
    final addedKeys = currentItemKeys.difference(prevItemKeys);
    currentItemModels.asMap().forEach((index, itemModel) {
      if (addedKeys.contains(itemModel.itemKey)) {
        _listKey.currentState!.insertItem(index);
      }
    });
  }

  Widget _buildItem(
      BuildContext context, ItemModel itemModel, Animation<double> animation,
      {double x = -1}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SlideTransition(
          position: Tween<Offset>(begin: Offset(x, 0), end: Offset.zero)
              .animate(animation),
          child: ItemOverviewListEntry(itemModel)),
    );
  }
}
