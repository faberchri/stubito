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
  static const String titleFieldLabel = 'Titel';

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
    final overviewListTitleField = TextFieldSpec(
        label: titleFieldLabel,
        showLabelInGui: true,
        placeholderText: 'Was gibt es zu tun?');
    final fields = UnmodifiableListView<FieldSpec>([
      overviewListTitleField,
      SelectionFieldSpec(
          label: 'Prio',
          showLabelInGui: true,
          options: UnmodifiableListView(['tief', 'mittel', 'hoch'])),
      DateFieldSpec(
          label: 'Bis wann erledigt?',
          showLabelInGui: true,
          initialValueProvider: () => DateTime.now().add(Duration(days: 1)))
    ]);

    return TodoItemSpec._(overviewListTitleField, fields);
  }
}
