import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/tour_list.dart';

import 'components/detail_text_input_field.dart';

class TourDetail extends StatefulWidget {

  static const routeName = '/detail';

  @override
  State createState() {
    return _TourDetailState();
  }

}

typedef TourModel _TourModelUpdater(TourModel m);

class _TourDetailState extends State<TourDetail> {

  final titleSubject = BehaviorSubject<String>();
  final dateSubject = BehaviorSubject<DateTime>();
  final locationSubject = BehaviorSubject<String>();
  final participantsSubject = BehaviorSubject<List<String>>();
  final routeDescriptionSubject = BehaviorSubject<String>();
  final avalancheRiskSubject = BehaviorSubject<AvalancheRisk>();
  final ascentAltitudeMetersSubject = BehaviorSubject<int>();
  final ascentDurationSubject = BehaviorSubject<Duration>();
  final weatherSubject = BehaviorSubject<String>();
  final temperatureSubject = BehaviorSubject<String>();
  final snowConditionSubject = BehaviorSubject<String>();
  final perceivedRiskSubject = BehaviorSubject<String>();
  final criticalSectionsSubject = BehaviorSubject<String>();
  final remarksSubject = BehaviorSubject<String>();

  TourModel? model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model = context.read<TourListModel>().getSelectedOrNewTour();
  }



  void _updateModel(BuildContext context, _TourModelUpdater updater) {
    //final l = context.read<TourListModel>();
    //final m = l.getSelectedOrNewTour();
    final um = updater(model!);
    //l.updateTour(um);
    context.read<TourListModel>().updateTour(um);
    setState(() {
      model = um;
    });
  }

  void _initModelUpdaters(BuildContext context) {
    titleSubject.listen((value) {
      _updateModel(context, (m) => m.copy(title: value));
    });
    dateSubject.listen((value) {
      _updateModel(context, (m) => m.copy(date: value));
    });
    locationSubject.listen((value) {
      _updateModel(context, (m) => m.copy(location: value));
    });
    participantsSubject.listen((value) {
      _updateModel(context, (m) => m.copy(participants: value));
    });
    routeDescriptionSubject.listen((value) {
      _updateModel(context, (m) => m.copy(routeDescription: value));
    });
    avalancheRiskSubject.listen((value) {
      _updateModel(context, (m) => m.copy(avalancheRisk: value));
    });
    ascentAltitudeMetersSubject.listen((value) {
      _updateModel(context, (m) => m.copy(ascentAltitudeMeters: value));
    });
    ascentDurationSubject.listen((value) {
      _updateModel(context, (m) => m.copy(ascentDuration: value));
    });
    weatherSubject.listen((value) {
      _updateModel(context, (m) => m.copy(weather: value));
    });
    temperatureSubject.listen((value) {
      _updateModel(context, (m) => m.copy(temperature: value));
    });
    snowConditionSubject.listen((value) {
      _updateModel(context, (m) => m.copy(snowCondition: value));
    });
    perceivedRiskSubject.listen((value) {
      _updateModel(context, (m) => m.copy(perceivedRisk: value));
    });
    criticalSectionsSubject.listen((value) {
      _updateModel(context, (m) => m.copy(criticalSections: value));
    });
    remarksSubject.listen((value) {
      _updateModel(context, (m) => m.copy(remarks: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    //final tourListModel = context.read<TourListModel>();
    //var initialModel = tourListModel.getSelectedOrNewTour();

    _initModelUpdaters(context);

    final titleField = TourDetailTextInputField('Title', model!.title, titleSubject);
    final remarksField = TourDetailTextInputField('Remarks', model!.remarks, remarksSubject);



    return WillPopScope(
        child:
        Scaffold(
          appBar: AppBar(
            title: Text('Tour Details'),
          ),
          body: ListView(
              children: [
                titleField,
                remarksField,
              ]
          ),
        ),
        onWillPop: () {
          //tourListModel.deselectTour();
          //Navigator.pop(context);

          context.read<TourListModel>().deselectTour();

          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
          return Future.value(true);
              //.whenComplete(() => context.read<TourListModel>().removeEmptyTours());
        });

    // return Scaffold(
    //       appBar: AppBar(
    //         title: Text('Tour Details'),
    //       ),
    //       body: ListView(
    //           children: [
    //             titleField,
    //             remarksField,
    //           ]
    //       ),
    //     );
  }

  @override
  void dispose() {
    titleSubject.close();
    dateSubject.close();
    locationSubject.close();
    participantsSubject.close();
    routeDescriptionSubject.close();
    avalancheRiskSubject.close();
    ascentAltitudeMetersSubject.close();
    ascentDurationSubject.close();
    weatherSubject.close();
    temperatureSubject.close();
    snowConditionSubject.close();
    perceivedRiskSubject.close();
    criticalSectionsSubject.close();
    remarksSubject.close();
    super.dispose();
  }
}
