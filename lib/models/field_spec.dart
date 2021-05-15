import 'dart:collection';

typedef InitialValueProvider<T> = T Function();

abstract class FieldSpecVisitor<R> {
  R visitTextFieldSpec(TextFieldSpec spec);
  R visitSelectionFieldSpec(SelectionFieldSpec spec);
  R visitDateFieldSpec(DateFieldSpec spec);
}

abstract class FieldSpec<T> {
  final String label;
  final bool showLabelInGui;
  final InitialValueProvider<T> initialValueProvider;

  FieldSpec(this.label, this.showLabelInGui, this.initialValueProvider);
  R accept<R>(FieldSpecVisitor<R> visitor);
}

class TextFieldSpec extends FieldSpec<String> {
  final String placeholderText;

  TextFieldSpec(String label, bool showLabelInGui, this.placeholderText,
      {String initialValue = ''})
      : super(label, showLabelInGui, () => '');

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitTextFieldSpec(this);
  }
}

class SelectionFieldSpec extends FieldSpec<String> {
  final UnmodifiableListView<String> options;

  SelectionFieldSpec(String label, bool showLabelInGui, this.options,
      {String? initialValue})
      : super(label, showLabelInGui, () => initialValue ?? options[0]);

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitSelectionFieldSpec(this);
  }
}

class DateFieldSpec extends FieldSpec<DateTime> {
  DateFieldSpec(String label, bool showLabelInGui,
      {InitialValueProvider<DateTime>? initialValueProvider})
      : super(label, showLabelInGui,
            initialValueProvider ?? () => DateTime.now());

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitDateFieldSpec(this);
  }
}
