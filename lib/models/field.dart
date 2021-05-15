import 'package:equatable/equatable.dart';

import 'field_spec.dart';

abstract class FieldModelVisitor<R> {
  R visitTextFieldModel(TextFieldModel model);

  R visitSelectionFieldModel(SelectionFieldModel model);
  R visitDateFieldModel(DateFieldModel model);
}

abstract class FieldModel<T> {
  abstract final FieldSpec<T> spec;
  abstract final T value;

  FieldModel<T> copy(T newValue);
  R accept<R>(FieldModelVisitor<R> visitor);
}

class TextFieldModel with EquatableMixin implements FieldModel<String> {

  @override
  final TextFieldSpec spec;

  @override
  final String value;

  TextFieldModel._(this.spec, this.value);

  TextFieldModel(TextFieldSpec spec)
      : spec = spec,
        value = spec.initialValueProvider();

  @override
  List<Object> get props => [spec, value];

  @override
  TextFieldModel copy(String newValue) {
    return TextFieldModel._(spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitTextFieldModel(this);
  }
}

class SelectionFieldModel with EquatableMixin implements FieldModel<String> {

  @override
  final SelectionFieldSpec spec;

  @override
  final String value;

  SelectionFieldModel._(this.spec, this.value);

  SelectionFieldModel(SelectionFieldSpec spec)
      : spec = spec,
        value = spec.initialValueProvider();

  @override
  List<Object> get props => [spec, value];

  @override
  SelectionFieldModel copy(String newValue) {
    return SelectionFieldModel._(spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitSelectionFieldModel(this);
  }
}

class DateFieldModel with EquatableMixin implements FieldModel<DateTime> {

  @override
  final DateFieldSpec spec;

  @override
  final DateTime value;

  DateFieldModel._(this.spec, this.value);

  DateFieldModel(DateFieldSpec spec)
      : spec = spec,
        value = spec.initialValueProvider();

  @override
  List<Object> get props => [spec, value];

  @override
  DateFieldModel copy(DateTime newValue) {
    return DateFieldModel._(spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitDateFieldModel(this);
  }
}
