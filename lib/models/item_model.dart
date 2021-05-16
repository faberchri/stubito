import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:tour_log/models/field_model_visitor.dart';
import 'package:tour_log/models/item_spec.dart';
import 'package:uuid/uuid.dart';

import 'field_model.dart';
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
    final titleFieldModel = fields.firstWhere(_overviewListTitleFieldFilter());
    final titleFieldDefaultModel =
        defaults.firstWhere(_overviewListTitleFieldFilter());
    if (titleFieldDefaultModel != titleFieldModel) {
      return _toOverviewListStringRepresentation(titleFieldModel);
    }
    return itemSpec.overviewListDefaultTitle;
  }

  String? getOverviewListSubtitle() {
    if (itemSpec.overviewListSubtitleField == null) {
      return null;
    }
    final subtitleFieldModel =
        fields.firstWhere(_overviewListSubtitleFieldFilter());
    final subtitleFieldDefaultModel =
        defaults.firstWhere(_overviewListSubtitleFieldFilter());
    if (subtitleFieldDefaultModel != subtitleFieldModel) {
      return _toOverviewListStringRepresentation(subtitleFieldModel);
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

  bool Function(FieldModel) _overviewListTitleFieldFilter() {
    return (FieldModel m) => m.spec == itemSpec.overviewListTitleField;
  }

  bool Function(FieldModel) _overviewListSubtitleFieldFilter() {
    return (FieldModel m) => m.spec == itemSpec.overviewListSubtitleField;
  }

  String _toOverviewListStringRepresentation(FieldModel model) {
    return mapField(
        onTextField: (m) => m.value,
        onSelectionField: (m) => m.value,
        onDateField: (m) => DateFormat.yMd().add_Hm().format(m.value))(model);
  }
}
