import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:tour_log/models/WordPairSelection.dart';
import 'package:tour_log/models/tour.dart';
import 'package:tour_log/models/tourlist.dart';
import 'package:tour_log/screens/home/components/randomwords.dart';

// //NewTour newTour(BuildContext context) {
//   //var tourListModel = context.read<TourListModel>();
//   //return NewTour(tourModel: tourListModel.newTour());
//   //return NewTour(tourModel: TourModel());
// //}
//
// class NewTour extends StatelessWidget {
//   static const routeName = '/new';
//
//   //final TourModel tourModel;
//
//   //const NewTour({ required this.tourModel, Key? key }) : super(key: key);
//
//   //NewTour(this.tourModel) ;
//
//   @override
//   Widget build(BuildContext context) {
//     var tourListModel = context.read<TourListModel>();
//     return TourDetail(tourListModel.newTour(), 'Neue Tour');
//     //return TourDetail(TourModel(), 'bla');
//     //return TourDetail(tourModel, 'flu');
//   }
//
//
// }
//
// class ExistingTour extends StatelessWidget {
//   static const routeName = '/detail';
//
//   @override
//   Widget build(BuildContext context) {
//     // FIXME
//     var tourListModel = context.watch<TourListModel>();
//     return TourDetail(tourListModel.newTour(), 'Existierende Tour');
//   }
//
//
// }

class TourDetail extends StatelessWidget {

  static const routeName = '/detail';

  //final TourModel model;
  //final String title;

  //TourDetail(this.model, this.title);

  @override
  Widget build(BuildContext context) {
    final tourListModel = context.watch<TourListModel>();
    var model = tourListModel.getSelectedOrNewTour();
    return Scaffold(
      appBar: AppBar(
        title: Text('Tour Details'),
      ),
      body: ListView(children: [Text(model.title), Text(model.key.toString())]),
    );
  }

}

