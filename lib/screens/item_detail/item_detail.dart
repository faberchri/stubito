import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/models/field_spec.dart';
import 'package:tour_log/models/item.dart';
import 'package:tour_log/models/item_spec.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/item_list.dart';

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
    this.itemModel = context.read<ItemListModel>().getSelectedOrNewItem();
  }

  void _initModelUpdaters(BuildContext context) {

      fieldModelChanges.listen((value) {
        final localItemModel = itemModel;
        if (localItemModel != null) {
          final newItemModel = localItemModel.copy(value);
          context.read<ItemListModel>().updateItem(newItemModel);
          setState(() {
            itemModel = newItemModel;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    _initModelUpdaters(context);

    final widgetResolverVisitor = _WidgetResolverVisitor(fieldModelChanges);
    final fieldWidgets = itemModel!.fields.map((e) => e.accept(widgetResolverVisitor)).toList();

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tour Details'),
          ),
          body: ListView(children: fieldWidgets),
        ),
        onWillPop: () {
          // Required for proper animation on quick addition of new item.
          // (prevent wrong 'remove empty animation')
          FocusScope.of(context).focusedChild?.unfocus();
          return Future.value(true);
        });
  }

  @override
  void dispose() {
    fieldModelChanges.close();
    super.dispose();
  }
}

class _WidgetResolverVisitor extends FieldModelVisitor<Widget> {

  final BehaviorSubject<FieldModel> subject;

  _WidgetResolverVisitor(this.subject);

  @override
  Widget visitTextFieldModel(TextFieldModel model) {
    return ItemDetailTextInputField(model, subject);
  }

  @override
  Widget visitDateFieldModel(DateFieldModel model) {
    return Text(model.value.toIso8601String());
  }

  @override
  Widget visitSelectionFieldModel(SelectionFieldModel model) {
    return Text('Selected: ${model.value} - ${model.spec.options.toString()}');
  }
}
