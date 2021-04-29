import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TourDetailTextInputField extends StatefulWidget {
  final String placeholder;
  final String initialValue;
  final Subject<String> updateSubject;

  TourDetailTextInputField(
      this.placeholder, this.initialValue, this.updateSubject);

  @override
  State createState() {
    return _TourDetailTextInputFieldState(initialValue);
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
        widget.updateSubject.add(event);
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
            widget.updateSubject.add(_controller.text);
          }
        },
        child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: widget.placeholder,
            )));
  }
}
