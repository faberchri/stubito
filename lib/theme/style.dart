import 'package:flutter/material.dart';

const double marginDetailList = 10;
const double defaultMarginBottomSheet = 10;
const double bottomSheetBorderRadius = 25;
const double defaultBottomSheetMaxHeightFraction = 0.8;

ThemeData appTheme() {
  return ThemeData(
      primarySwatch: Colors.blueGrey,
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(bottomSheetBorderRadius))),
      ));
}
