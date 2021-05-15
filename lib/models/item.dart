import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_log/models/item_spec.dart';
import 'package:uuid/uuid.dart';

import 'field.dart';
import 'field_spec.dart';

@immutable
class ItemKey extends Equatable {
  static const uuidGen = Uuid();
  final id = uuidGen.v1();

  @override
  List<Object> get props {
    return [id];
  }
}

class FieldModelCreatorVisitor extends FieldSpecVisitor<FieldModel> {
  @override
  FieldModel visitTextFieldSpec(TextFieldSpec spec) {
    return TextFieldModel(spec);
  }

  @override
  FieldModel visitDateFieldSpec(DateFieldSpec spec) {
    return DateFieldModel(spec);
  }

  @override
  FieldModel visitSelectionFieldSpec(SelectionFieldSpec spec) {
    return SelectionFieldModel(spec);
  }
}

@immutable
class ItemModel extends Equatable {
  final ItemKey itemKey;
  final ItemSpec itemSpec;
  final UnmodifiableListView<FieldModel> fields;
  final UnmodifiableListView<FieldModel> defaults;

  ItemModel._(this.itemKey, this.itemSpec, this.fields, this.defaults);

  factory ItemModel(ItemSpec itemSpec) {
    final fieldModelCreatorVisitor = FieldModelCreatorVisitor();
    final fieldModels = UnmodifiableListView(itemSpec.fields
        .map((e) => e.accept(fieldModelCreatorVisitor))
        .toList(growable: false));
    return ItemModel._(ItemKey(), itemSpec, fieldModels, fieldModels);
  }

  @override
  List<Object> get props => [
        itemKey,
        itemSpec,
        fields,
        defaults,
      ];

  String getOverviewListTitle() {
    final titleFieldModel = fields.firstWhere(
        (element) => element.spec == itemSpec.overviewListTitleField);
    final titleFieldDefaultModel = defaults.firstWhere(
        (element) => element.spec == itemSpec.overviewListTitleField);
    if (titleFieldDefaultModel != titleFieldModel) {
      return titleFieldModel.value
          .toString(); // FIXME title string representation for all field types
    }
    return itemSpec.overviewListDefaultTitle;
  }

  String? getOverviewListSubtitle() {
    if (itemSpec.overviewListSubtitleField == null) {
      return null;
    }
    final subtitleFieldModel = fields.firstWhere(
        (element) => element.spec == itemSpec.overviewListSubtitleField);
    final subtitleFieldDefaultModel = defaults.firstWhere(
        (element) => element.spec == itemSpec.overviewListSubtitleField);
    if (subtitleFieldDefaultModel != subtitleFieldModel) {
      return subtitleFieldModel.value
          .toString(); // FIXME title string representation for all field types
    }
    return null;
  }

  bool hasAllDefaultValues() {
    return fields == defaults;
  }

  ItemModel copy(FieldModel newFieldModel) {
    final newFields = UnmodifiableListView(fields
        .map((e) => e.spec == newFieldModel.spec ? newFieldModel : e)
        .toList());
    return ItemModel._(itemKey, itemSpec, newFields, defaults);
  }
}
