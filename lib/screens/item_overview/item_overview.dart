import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_log/models/item_list_model.dart';

import '../../routes.dart';
import 'components/item_list.dart';

class ItemOverview extends StatefulWidget {
  static const routeName = '/';

  @override
  State createState() {
    return _ItemOverviewState();
  }
}

class _ItemOverviewState extends State<ItemOverview> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deine Touren'),
      ),
      body: Center(
        child: ItemList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ItemListModel>().newItem();
          navigateToDetail(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    final itemList = context.read<ItemListModel>();
    itemList.removeEmptyItems();
    itemList.deselectItem();
  }
}
