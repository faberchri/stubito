import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/models/field_model.dart';

class ItemDetailTextInputField extends StatefulWidget {
  final Subject<FieldModel> updateSubject;
  final TextFieldModel textFieldModel;

  ItemDetailTextInputField(this.textFieldModel, this.updateSubject);

  @override
  State createState() {
    return _ItemDetailTextInputFieldState(textFieldModel.value);
  }
}

class _ItemDetailTextInputFieldState extends State<ItemDetailTextInputField> {
  final TextEditingController _controller;
  final _debounceChange = BehaviorSubject<String>();

  _ItemDetailTextInputFieldState(String initialValue)
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
            widget.updateSubject
                .add(widget.textFieldModel.copy(_controller.text));
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
