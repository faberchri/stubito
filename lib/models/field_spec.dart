import 'dart:collection';

typedef InitialValueProvider<T> = T Function();

abstract class FieldSpecVisitor<R> {
  R visitTextFieldSpec(TextFieldSpec spec);
  R visitSelectionFieldSpec(SelectionFieldSpec spec);
  R visitDateFieldSpec(DateFieldSpec spec);
}

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
      required bool showLabelInGui,
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

  SelectionFieldSpec(
      {required String label,
      required bool showLabelInGui,
      required this.options,
      String? initialValue})
      : initialValueProvider = (() => initialValue ?? options[0]),
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
      required bool showLabelInGui,
      InitialValueProvider<DateTime>? initialValueProvider})
      : initialValueProvider = (initialValueProvider ?? () => DateTime.now()),
        super(label: label, showLabelInGui: showLabelInGui);

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitDateFieldSpec(this);
  }
}
