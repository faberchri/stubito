import 'package:equatable/equatable.dart';

import 'field_model_visitor.dart';
import 'field_spec.dart';

abstract class FieldModel {
  abstract final FieldSpec spec;
  R accept<R>(FieldModelVisitor<R> visitor);
}

class TextFieldModel with EquatableMixin implements FieldModel {
  @override
  final TextFieldSpec spec;

  final String value;

  TextFieldModel._(this.spec, this.value);

  TextFieldModel(TextFieldSpec spec)
      : spec = spec,
        value = spec.initialValueProvider();

  @override
  List<Object> get props => [spec, value];

  TextFieldModel copy(String newValue) {
    return TextFieldModel._(spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitTextFieldModel(this);
  }
}

class SelectionFieldModel with EquatableMixin implements FieldModel {
  @override
  final SelectionFieldSpec spec;

  final String value;

  SelectionFieldModel._(this.spec, this.value);

  SelectionFieldModel(SelectionFieldSpec spec)
      : spec = spec,
        value = spec.initialValueProvider();

  @override
  List<Object> get props => [spec, value];

  SelectionFieldModel copy(String newValue) {
    return SelectionFieldModel._(spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitSelectionFieldModel(this);
  }
}

class DateFieldModel with EquatableMixin implements FieldModel {
  @override
  final DateFieldSpec spec;

  final DateTime value;

  DateFieldModel._(this.spec, this.value);

  DateFieldModel(DateFieldSpec spec)
      : spec = spec,
        value = spec.initialValueProvider();

  @override
  List<Object> get props => [spec, value];

  DateFieldModel copy(DateTime newValue) {
    return DateFieldModel._(spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitDateFieldModel(this);
  }
}
