import 'dart:collection';


import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'field_spec.dart';

abstract class ItemSpec {

  abstract final String itemNamePlural;

  abstract final UnmodifiableListView<FieldSpec> fields;

}


@immutable
class ItemKey extends Equatable {
  static const uuidGen = Uuid();
  final id = uuidGen.v1();

  @override
  List<Object> get props {
    return [id];
  }
}

@immutable
class ItemModel extends Equatable {
  final ItemKey itemKey;
  final UnmodifiableListView<FieldModel> fields;

  ItemModel(this.itemKey, this.fields);

  @override
  List<Object> get props => [
    itemKey,
    fields
  ];

  ItemModel copy(FieldModel newFieldModel) {
    return new ItemModel(itemKey,
        UnmodifiableListView(fields.map((e) => e.spec == newFieldModel.spec ? newFieldModel : e).toList()));
  }

}

class TodoItemSpec implements ItemSpec {

  @override
  String get itemNamePlural => 'Todos';

  @override
  final UnmodifiableListView<FieldSpec> fields
  = UnmodifiableListView([
    TextFieldSpec('Titel', true, 'Was gibt es zu tun?'),
    SelectionFieldSpec('Prio', true, UnmodifiableListView(['tief', 'mittel', 'hoch'])),
    DateFieldSpec('Bis wann erledigt?', true, initialValueProvider: () => DateTime.now().add(Duration(days: 1)))
  ]);
}

