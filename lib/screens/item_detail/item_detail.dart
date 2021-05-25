import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/models/field_model.dart';
import 'package:tour_log/models/field_model_visitor.dart';
import 'package:tour_log/models/item_list_model.dart';
import 'package:tour_log/models/item_model.dart';
import 'package:tour_log/screens/item_detail/components/selection_field.dart';
import 'package:tour_log/theme/style.dart';

import 'components/detail_text_input_field.dart';

class ItemDetail extends StatefulWidget {
  static const routeName = '/detail';

  @override
  State createState() {
    return _ItemDetailState();
  }
}

class _ItemDetailState extends State<ItemDetail> {
  final fieldModelChanges = BehaviorSubject<FieldModel>();

  ItemModel? itemModel;

  @override
  void initState() {
    super.initState();
    itemModel = context.read<ItemListModel>().getSelectedOrNewItem();
    _initModelUpdaters();
  }

  void _initModelUpdaters() {
    fieldModelChanges.listen((value) {
      final im = itemModel;
      if (im != null) {
        final newItemModel = im.copy(value);
        context.read<ItemListModel>().updateItem(newItemModel);
        setState(() {
          itemModel = newItemModel;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Required for proper animation on quick addition of new item.
        // (prevent wrong 'remove empty animation')
        FocusScope.of(context).focusedChild?.unfocus();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tour Details'),
        ),
        body: Container(
            margin: const EdgeInsets.all(marginDetailList),
            child: ListView(
              shrinkWrap: true,
              children: createFieldWidgets(),
            )),
      ),
    );
  }

  @override
  void dispose() {
    fieldModelChanges.close();
    super.dispose();
  }

  List<Widget> createFieldWidgets() {
    final im = itemModel;
    if (im != null) {
      return im.fields
          .map(mapField(
            onTextField: (m) => ItemDetailTextInputField(m, fieldModelChanges),
            onSelectionField: (m) =>
                ItemDetailSelectionField(m, fieldModelChanges),
            onDateField: (m) => Text(m.value.toIso8601String()),
          )) // FIXME
          .toList();
    }
    return [];
  }
}
