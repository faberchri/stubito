import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/tour_list.dart';

class TourDetail extends StatefulWidget {

  static const routeName = '/detail';

  @override
  State createState() {
    return _TourDetailState();
  }

}

class _TourDetailState extends State<TourDetail> {

  final titleSubject = BehaviorSubject<String>();
  final remarksSubject = BehaviorSubject<String>();


  @override
  Widget build(BuildContext context) {
    final tourListModel = context.read<TourListModel>();
    var initialModel = tourListModel.getSelectedOrNewTour();


    //titleSubject.map((v) => (TourModel m) => m.copy(title: v));
    //remarksSubject.map((v) => (TourModel m) => m.copy(remarks: v));

    titleSubject.listen((value) {
      final l = context.read<TourListModel>();
      final m = tourListModel.getSelectedOrNewTour();
      l.updateTour(m.copy(title: value));
    });
    remarksSubject.listen((value) {
      final l = context.read<TourListModel>();
      final m = tourListModel.getSelectedOrNewTour();
      l.updateTour(m.copy(remarks: value));
    });

    //final debouncedTitleSubject = titleSubject.debounceTime(Duration(milliseconds: 500));

    final titleField = TourDetailTextInputField('Title', initialModel.title, titleSubject);
    final remarksField = TourDetailTextInputField('Remarks', initialModel.remarks, remarksSubject);





    return Scaffold(
      appBar: AppBar(
        title: Text('Tour Details'),
      ),
      body: ListView(
          children: [
            titleField,
            remarksField,
            // TourDetailTextInputField(
            //     model.title,
            //         (newValue) {
            //       print(newValue);
            //       final newModel = model.copy(title: newValue);
            //       tourListModel.updateTour(newModel);
            //     })
          ]
      ),
    );
  }

  @override
  void dispose() {
    titleSubject.close();
    remarksSubject.close();
    super.dispose();
  }
}


class TourDetailTextInputField extends StatefulWidget {

  final String label;
  final String initialValue;
  final Subject<String> subject;

  TourDetailTextInputField(this.label, this.initialValue, this.subject);

  @override
  State createState() {
    return _TourDetailTextInputFieldState(this.label, initialValue, subject);
  }
}


class _TourDetailTextInputFieldState extends State<TourDetailTextInputField> {

  final String label;
  final TextEditingController _controller;
  //final FocusNode _focusNode;
  final Subject<String> subject;
  final _debounceChange = BehaviorSubject<String>();

  _TourDetailTextInputFieldState(this.label, String value, this.subject)
      : _controller = TextEditingController(text: value);

  // @override
  // void initState() {
  //   super.initState();
  //
  //   title = model.title;
  // }

  @override
  void initState() {
    super.initState();

    //_addToSubject();
    //_controller.addListener(() {
    //  //onChange(_controller.text);
    //  _addToSubject();
    //});

    _debounceChange.debounceTime(Duration(milliseconds: 5000))
        .listen((event) {print(event);
        if (!this.subject.isClosed) {
          this.subject.add(event);
        }
        });


    _controller.addListener(() {
      //onChange(_controller.text);
      _debounceChange.add(_controller.text);
    });


    //_focusNode.addListener(() { })
  }

  void _addToSubject() {
    subject.add(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    //_focusNode.dispose();
    _debounceChange.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

            return Focus(
              onFocusChange: (hasFocus){
                if (!hasFocus) {
                  this.subject.add(_controller.text);
                }
              },

            child: TextField(
                controller: _controller,
                //focusNode: _focusNode,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: label
                )
            )
            );

  }
}
