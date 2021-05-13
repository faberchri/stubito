import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

typedef T InitialValueProvider<T>();

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

  TextFieldSpec(String label,
      bool showLabelInGui,
      this.placeholderText,
      {String initialValue = ''})
      : super(label, showLabelInGui, () => '');

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitTextFieldSpec(this);
  }
}

class SelectionFieldSpec extends FieldSpec<String> {

  final UnmodifiableListView<String> options;

  SelectionFieldSpec(String label, bool showLabelInGui, this.options, {String? initialValue})
      : super(label, showLabelInGui, () => initialValue ?? options[0]);

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitSelectionFieldSpec(this);
  }
}

class DateFieldSpec extends FieldSpec<DateTime> {

  DateFieldSpec(String label, bool showLabelInGui, {InitialValueProvider<DateTime>? initialValueProvider})
      : super(label, showLabelInGui, initialValueProvider ?? () => DateTime.now());

  @override
  R accept<R>(FieldSpecVisitor<R> visitor) {
    return visitor.visitDateFieldSpec(this);
  }
}

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

class TextFieldModel with EquatableMixin implements FieldModel<String>  {
  final TextFieldSpec spec;
  final String value;

  TextFieldModel._(this.spec, this.value);

  TextFieldModel(TextFieldSpec spec)
      : this.spec = spec,
        this.value = spec.initialValueProvider();

  @override
  List<Object> get props => [
    spec,
    value
  ];

  @override
  TextFieldModel copy(String newValue) {
    return TextFieldModel._(spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitTextFieldModel(this);
  }
}


class SelectionFieldModel with EquatableMixin implements FieldModel<String>  {
  final SelectionFieldSpec spec;
  final String value;

  SelectionFieldModel._(this.spec, this.value);

  SelectionFieldModel(SelectionFieldSpec spec)
      : this.spec = spec,
        this.value = spec.initialValueProvider();

  @override
  List<Object> get props => [
    spec,
    value
  ];

  @override
  SelectionFieldModel copy(String newValue) {
    return SelectionFieldModel._(this.spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitSelectionFieldModel(this);
  }
}

class DateFieldModel with EquatableMixin implements FieldModel<DateTime> {
  final DateFieldSpec spec;
  final DateTime value;

  DateFieldModel._(this.spec, this.value);

  DateFieldModel(DateFieldSpec spec)
      : this.spec = spec,
        this.value = spec.initialValueProvider();

  @override
  List<Object> get props => [
    spec,
    value
  ];

  @override
  DateFieldModel copy(DateTime newValue) {
    return DateFieldModel._(this.spec, newValue);
  }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitDateFieldModel(this);
  }
}