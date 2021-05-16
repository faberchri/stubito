import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/item_list_model.dart';
import 'package:tour_log/models/item_model.dart';
import 'package:tour_log/theme/style.dart';

import '../../../routes.dart';

class ItemOverviewListEntry extends StatelessWidget {
  final ItemModel itemModel;

  ItemOverviewListEntry(this.itemModel);

  @override
  Widget build(BuildContext context) {
    final subtitle = itemModel.getOverviewListSubtitle();
    final subtitleWidget = subtitle != null ? Text(subtitle) : null;
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        key: ValueKey(itemModel.itemKey),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: appTheme().errorColor,
            icon: Icons.delete,
            onTap: () {
              context.read<ItemListModel>().deleteItem(itemModel.itemKey);
            },
          ),
        ],
        child: ListTile(
            title: Text(itemModel.getOverviewListTitle()),
            subtitle: subtitleWidget,
            onTap: () {
              context.read<ItemListModel>().selectItem(itemModel.itemKey);
              navigateToDetail(context);
            }));
  }
}
