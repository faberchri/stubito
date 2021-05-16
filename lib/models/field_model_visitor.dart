import 'package:flutter/material.dart';

import 'field_model.dart';

@immutable
abstract class FieldModelVisitor<R> {
  R visitTextFieldModel(TextFieldModel model);
  R visitSelectionFieldModel(SelectionFieldModel model);
  R visitDateFieldModel(DateFieldModel model);
}

// dart does not allow anonymous classes,
// but we can use anonymous functions to mimic the behaviour.
// https://stackoverflow.com/a/58894632/2584278
class FunctionalFieldModelVisitor<R> implements FieldModelVisitor<R> {
  final R Function(TextFieldModel model) onTextField;
  final R Function(SelectionFieldModel model) onSelectionField;
  final R Function(DateFieldModel model) onDateField;

  FunctionalFieldModelVisitor(
      {required R Function(TextFieldModel m) onTextField,
      required R Function(SelectionFieldModel m) onSelectionField,
      required R Function(DateFieldModel m) onDateField})
      : onTextField = onTextField,
        onSelectionField = onSelectionField,
        onDateField = onDateField;

  @override
  R visitTextFieldModel(TextFieldModel model) => onTextField(model);

  @override
  R visitSelectionFieldModel(SelectionFieldModel model) =>
      onSelectionField(model);

  @override
  R visitDateFieldModel(DateFieldModel model) => onDateField(model);
}

R Function(FieldModel) mapField<R>(
    {required R Function(TextFieldModel m) onTextField,
    required R Function(SelectionFieldModel m) onSelectionField,
    required R Function(DateFieldModel m) onDateField}) {
  final visitor = FunctionalFieldModelVisitor<R>(
      onTextField: onTextField,
      onSelectionField: onSelectionField,
      onDateField: onDateField);
  return (model) => model.accept(visitor);
}

bool Function(FieldModel) filterField(
    {required bool Function(TextFieldModel m) onTextField,
    required bool Function(SelectionFieldModel m) onSelectionField,
    required bool Function(DateFieldModel m) onDateField}) {
  return mapField(
      onTextField: onTextField,
      onSelectionField: onSelectionField,
      onDateField: onDateField);
}

R Function(FieldModel) mapFieldOrDefaultValue<R>(R defaultValue,
    {R Function(TextFieldModel m)? onTextField,
    R Function(SelectionFieldModel m)? onSelectionField,
    R Function(DateFieldModel m)? onDateField}) {
  final visitor = FunctionalFieldModelVisitor<R>(
      onTextField: onTextField ?? ((m) => defaultValue),
      onSelectionField: onSelectionField ?? ((m) => defaultValue),
      onDateField: onDateField ?? ((m) => defaultValue));
  return (model) => model.accept(visitor);
}

bool Function(FieldModel) _filterFieldWithDefaultBehaviour(
    {required bool excludeIfFilterFunctionUndefined,
    bool Function(TextFieldModel m)? onTextField,
    bool Function(SelectionFieldModel m)? onSelectionField,
    bool Function(DateFieldModel m)? onDateField}) {
  return mapFieldOrDefaultValue(!excludeIfFilterFunctionUndefined,
      onTextField: onTextField,
      onSelectionField: onSelectionField,
      onDateField: onDateField);
}

bool Function(FieldModel) filterFieldOrIgnore(
    {bool Function(TextFieldModel m)? onTextField,
    bool Function(SelectionFieldModel m)? onSelectionField,
    bool Function(DateFieldModel m)? onDateField}) {
  return _filterFieldWithDefaultBehaviour(
      excludeIfFilterFunctionUndefined: true,
      onTextField: onTextField,
      onSelectionField: onSelectionField,
      onDateField: onDateField);
}

bool Function(FieldModel) filterFieldOrInclude(
    {bool Function(TextFieldModel m)? onTextField,
    bool Function(SelectionFieldModel m)? onSelectionField,
    bool Function(DateFieldModel m)? onDateField}) {
  return _filterFieldWithDefaultBehaviour(
      excludeIfFilterFunctionUndefined: false,
      onTextField: onTextField,
      onSelectionField: onSelectionField,
      onDateField: onDateField);
}
