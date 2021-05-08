import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/models/field_spec.dart';
import 'package:tour_log/models/item_spec.dart';
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
typedef ItemModel _ItemModelUpdater(ItemModel m);

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

  //UnmodifiableListView<BehaviorSubject<FieldModel>> fieldModels = UnmodifiableListView([]);

  final fieldModelChanges = BehaviorSubject<FieldModel>();

  TourModel? model;
  ItemModel? itemModel;

  @override
  void initState() {
    super.initState();
    model = context.read<TourListModel>().getSelectedOrNewTour();
    
    
    this.itemModel = context.read<ItemListModel>().getSelectedOrNewTour();
    //fieldModels = UnmodifiableListView(itemModel.fields.map((e) => BehaviorSubject<FieldModel>()).toList());
    
    //this.itemModel = itemModel;
  }

  void _updateModel(BuildContext context, _TourModelUpdater updater) {
    final um = updater(model!);
    context.read<TourListModel>().updateTour(um);
    setState(() {
      model = um;
    });
  }

  // void _updateModel2(BuildContext context, _ItemModelUpdater updater) {
  //   final um = updater(itemModel!);
  //   context.read<ItemListModel>().updateTour(um);
  //   setState(() {
  //     itemModel = um;
  //   });
  // }

  void _initModelUpdaters(BuildContext context) {

    // fieldModels.forEach((subject) {
    //   subject.listen((value) {
    //     final localItemModel = itemModel;
    //     if (localItemModel != null) {
    //       final newItemModel = localItemModel.copy(value);
    //       context.read<ItemListModel>().updateItem(newItemModel);
    //       setState(() {
    //         itemModel = newItemModel;
    //       });
    //     }
    //   });
    // });


      fieldModelChanges.listen((value) {
        final localItemModel = itemModel;
        if (localItemModel != null) {
          final newItemModel = localItemModel.copy(value);
          context.read<ItemListModel>().updateItem(newItemModel);
          setState(() {
            itemModel = newItemModel;
          });
        }
      });

    
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
    _initModelUpdaters(context);

    // final titleField =
    //     TourDetailTextInputField('Title', model!.title, titleSubject);
    // final remarksField =
    //     TourDetailTextInputField('Remarks', model!.remarks, remarksSubject);

    final widgetResolverVisitor = WidgetResolverVisitor(fieldModelChanges);
    final fieldWidgets = itemModel!.fields.map((e) => e.accept(widgetResolverVisitor)).toList();

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tour Details'),
          ),
          body: ListView(children: fieldWidgets),
        ),
        onWillPop: () {
          // Required for proper animation on quick addition of new item.
          // (prevent wrong 'remove empty animation')
          FocusScope.of(context).focusedChild?.unfocus();
          return Future.value(true);
        });
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

class WidgetResolverVisitor extends FieldModelVisitor<Widget> {

  final BehaviorSubject<FieldModel> subject;

  WidgetResolverVisitor(this.subject);

  @override
  Widget visitTextFieldModel(TextFieldModel model) {
    return TourDetailTextInputField(model, subject);
  }
}
