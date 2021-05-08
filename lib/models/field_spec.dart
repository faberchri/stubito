import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/screens/tour_detail/components/detail_text_input_field.dart';

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

  FieldModel<T> newModel() {
    return FieldModel(this, initialValueProvider());
  }

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

class ToWidgetVisitor extends FieldSpecVisitor<Widget> {

  final FieldModel fieldModel;

  @override
  Widget visit(TextFieldSpec spec) {
    return TourDetailTextInputField(spec.placeholderText, fieldModel.value, updateSubject)
  }
}

// class FieldModel<T> {
//   final FieldSpec<T> spec;
//   final T value;
//
//   FieldModel(this.spec, this.value);
//
//   FieldModel copy(T newValue) {
//     return FieldModel(spec, newValue);
//   }
//
//   bool hasDefaultValue() {
//     return spec.initialValueProvider() == value;
//   }
//
//   Widget toWidget() {
//     return spec.accept(ToWidgetVisitor());
//   }
//
//   //FieldModel(S spec, V value) : this.spec = spec, this.value = value;
// }

abstract class FieldModelVisitor<R> {
  R visitTextFieldModel(TextFieldModel model);
}

abstract class FieldModel<T> {

  FieldModel<T> copy(T newValue);
  //bool hasDefaultValue();
  //Widget toWidget(BehaviorSubject<T> subject);

   final FieldSpec<T> spec;
   final T value;

  R accept<R>(FieldModelVisitor<R> visitor);

}

class TextFieldModel extends FieldModel<String> {
  final TextFieldSpec spec;
  final String value;

  TextFieldModel(this.spec, this.value);

  @override
  FieldModel<String> copy(String newValue) {
    return TextFieldModel(spec, newValue);
  }



  // FieldModel copy(String newValue) {
  //   return FieldModel(spec, newValue);
  // }
  //
  // bool hasDefaultValue() {
  //   return spec.initialValueProvider() == value;
  // }
  //
  // Widget toWidget() {
  //   return spec.accept(ToWidgetVisitor());
  // }

  @override
  R accept<R>(FieldModelVisitor<R> visitor) {
    return visitor.visitTextFieldModel(this);
  }
}



//
// class SelectionFieldModel {
//   final SelectionFieldSpec spec;
//   final String value;
//
//   SelectionFieldModel(this.spec, this.value);
// }

