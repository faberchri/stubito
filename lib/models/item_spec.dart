import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'field_spec.dart';

@immutable
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
    final titleField = TextFieldSpec(
        label: titleFieldLabel, placeholderText: 'Was gibt es zu tun?');
    final fields = UnmodifiableListView<FieldSpec>([
      titleField,
      SelectionFieldSpec(
          label: 'Prio',
          optionNamePlural: 'Prioritäten',
          allowOptionFiltering: true,
          options: UnmodifiableListView(['tief', 'mittel', 'hoch'])),
      DateFieldSpec(
          label: 'Bis wann erledigt?',
          initialValueProvider: () => DateTime.now().add(Duration(days: 1)))
    ]);

    return TodoItemSpec._(titleField, fields);
  }
}

class TourItemSpec implements ItemSpec {
  @override
  final String itemNamePlural = 'Touren';
  @override
  final TextFieldSpec overviewListTitleField;
  @override
  final String overviewListDefaultTitle = 'Neue Tour';
  @override
  final TextFieldSpec overviewListSubtitleField;
  @override
  final UnmodifiableListView<FieldSpec> fields;

  TourItemSpec._(
      this.overviewListTitleField, this.overviewListSubtitleField, this.fields);

  factory TourItemSpec() {
    final titleField = TextFieldSpec(
        label: 'Titel',
        showLabelInGui: false,
        placeholderText: 'Gipfel, SAC-Tourname, o.ä.');
    final locationField =
        TextFieldSpec(label: 'Ort', placeholderText: 'Von wo bis wo?');

    final fields = UnmodifiableListView<FieldSpec>([
      titleField,
      DateFieldSpec(label: 'Datum'),
      locationField,
      TextFieldSpec(label: 'Teilnehmer', placeholderText: 'Wer war dabei?'),
      TextFieldSpec(label: 'Route', placeholderText: 'Beschreibung der Route'),
      TextFieldSpec(
          label: 'Dauer', placeholderText: 'Uhrzeit Start und Ende der Tour'),
      SelectionFieldSpec(
          label: 'Lawinengefahr',
          optionNamePlural: 'Gefahrenstufen',
          options: UnmodifiableListView(
              ['gering', 'mässig', 'erheblich', 'gross', 'sehr gross'])),
      TextFieldSpec(
          label: 'Aufstieg Höhenmeter',
          placeholderText: 'Total aufgestiegene Höhenmeter'),
      TextFieldSpec(
          label: 'Aufstieg Dauer', placeholderText: 'Totale Aufstiegszeit'),
      TextFieldSpec(
          label: 'Wetterverhältnisse',
          placeholderText: 'Sonne, Schneefall, Sichtverhältnisse, etc.'),
      TextFieldSpec(
          label: 'Temperatur',
          placeholderText:
              'Tatsächlicher Temperaturbereich und wahrgenommene Temperatur'),
      TextFieldSpec(
          label: 'Schneeverhältnisse',
          placeholderText: 'Pulver, Schneehöhe, Verwehungen, etc.'),
      TextFieldSpec(
          label: 'Wahrgnommenes Risiko',
          placeholderText:
              'Wie sicher hast du dich auf der Tour insgesamt gefühlt?'),
      TextFieldSpec(
          label: 'Kritische Stellen',
          placeholderText:
              'Bei welchen Stellen hattest du ein mulmiges Gefühl? Wieso? Gefahrenstellen.'),
      TextFieldSpec(
          label: 'Bemerkungen',
          placeholderText:
              'Ist sonst noch etwas interessantes oder aussergewöhnliches passiert?'),
    ]);

    return TourItemSpec._(titleField, locationField, fields);
  }
}
