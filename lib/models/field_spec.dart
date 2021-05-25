import 'dart:collection';

import 'package:flutter/foundation.dart';

typedef InitialValueProvider<T> = T Function();

@immutable
abstract class FieldSpecVisitor<R> {
  R visitTextFieldSpec(TextFieldSpec spec);
  R visitSelectionFieldSpec(SelectionFieldSpec spec);
  R visitDateFieldSpec(DateFieldSpec spec);
}

@immutable
abstract class FieldSpec {
  final String label;
  final bool showLabelInGui;

  FieldSpec({required this.label, required this.showLabelInGui});
  R accept<R>(FieldSpecVisitor<R> visitor);
}

class TextFieldSpec extends FieldSpec {
  final String placeholderText;
  final InitialValueProvider<String> initialValueProvider;

  TextFieldSpec(
      {required String label,
      bool showLabelInGui = true,
      required this.placeholderText,
      String initialValue = ''})
      : initialValueProvider = (() => initialValue),
        super(label: label, showLabelInGui: showLabelInGui);

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitTextFieldSpec(this);
  }
}

class SelectionFieldSpec extends FieldSpec {
  final UnmodifiableListView<String> options;
  final InitialValueProvider<String> initialValueProvider;
  final String optionNamePlural;
  final bool allowOptionFiltering;

  SelectionFieldSpec(
      {required String label,
      bool showLabelInGui = true,
      required this.options,
      String? initialValue,
      required this.optionNamePlural,
      bool? allowOptionFiltering})
      : initialValueProvider = (() => initialValue ?? options[0]),
        allowOptionFiltering = allowOptionFiltering ?? options.length > 5,
        super(label: label, showLabelInGui: showLabelInGui);

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitSelectionFieldSpec(this);
  }
}

class DateFieldSpec extends FieldSpec {
  final InitialValueProvider<DateTime> initialValueProvider;

  DateFieldSpec(
      {required String label,
      bool showLabelInGui = true,
      InitialValueProvider<DateTime>? initialValueProvider})
      : initialValueProvider = (initialValueProvider ?? () => DateTime.now()),
        super(label: label, showLabelInGui: showLabelInGui);

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitDateFieldSpec(this);
  }
}
