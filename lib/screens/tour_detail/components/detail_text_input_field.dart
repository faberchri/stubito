import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/models/field_spec.dart';

class TourDetailTextInputField extends StatefulWidget {
  final Subject<FieldModel> updateSubject;
  final TextFieldModel textFieldModel;

  TourDetailTextInputField(this.textFieldModel, this.updateSubject);

  @override
  State createState() {
    return _TourDetailTextInputFieldState(this.textFieldModel.value);
  }
}

class _TourDetailTextInputFieldState extends State<TourDetailTextInputField> {
  final TextEditingController _controller;
  final _debounceChange = BehaviorSubject<String>();

  _TourDetailTextInputFieldState(String initialValue)
      : _controller = TextEditingController(text: initialValue);

  @override
  void initState() {
    super.initState();

    _debounceChange.debounceTime(Duration(milliseconds: 500)).listen((event) {
      if (!widget.updateSubject.isClosed) {
        widget.updateSubject.add(widget.textFieldModel.copy(event));
      }
    });

    _controller.addListener(() {
      _debounceChange.add(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceChange.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            widget.updateSubject.add(widget.textFieldModel.copy(_controller.text));
          }
        },
        child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: widget.textFieldModel.spec.placeholderText,
            )));
  }
}
