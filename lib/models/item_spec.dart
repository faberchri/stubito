import 'dart:collection';

import 'field_spec.dart';

abstract class ItemSpec {
  abstract final String itemNamePlural;

  abstract final TextFieldSpec overviewListTitleField;
  abstract final String overviewListDefaultTitle;
  abstract final TextFieldSpec? overviewListSubtitleField;

  abstract final UnmodifiableListView<FieldSpec> fields;
}

class TodoItemSpec implements ItemSpec {
  @override
  String get itemNamePlural => 'Todos';

  @override
  final TextFieldSpec overviewListTitleField;

  @override
  final String overviewListDefaultTitle = 'Neues Todo';

  @override
  final TextFieldSpec? overviewListSubtitleField = null;

  @override
  final UnmodifiableListView<FieldSpec> fields;

  TodoItemSpec._(this.overviewListTitleField, this.fields);

  factory TodoItemSpec() {
    final overviewListTitleField =
        TextFieldSpec('Titel', true, 'Was gibt es zu tun?');
    final fields = UnmodifiableListView<FieldSpec>([
      overviewListTitleField,
      SelectionFieldSpec(
          'Prio', true, UnmodifiableListView(['tief', 'mittel', 'hoch'])),
      DateFieldSpec('Bis wann erledigt?', true,
          initialValueProvider: () => DateTime.now().add(Duration(days: 1)))
    ]);

    return TodoItemSpec._(overviewListTitleField, fields);
  }
}
