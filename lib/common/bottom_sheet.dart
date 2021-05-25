import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tour_log/theme/style.dart';

Future<void> showDynamicHeightModalBottomSheet(
    BuildContext context, WidgetBuilder modalContentBuilder,
    {double bottomSheetMaxHeightFraction = defaultBottomSheetMaxHeightFraction,
    EdgeInsetsGeometry margin =
        const EdgeInsets.all(defaultMarginBottomSheet)}) {
  return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (c) {
        // see https://stackoverflow.com/a/59541927/2584278
        return Wrap(children: [
          SafeArea(
            child: Container(
              margin: margin,
              constraints: BoxConstraints(
                  // screen height reduced by space covered by keyboard
                  maxHeight: (MediaQuery.of(c).size.height -
                          MediaQuery.of(c).viewInsets.bottom) *
                      bottomSheetMaxHeightFraction),
              child: modalContentBuilder(c),
            ),
          )
        ]);
      });
}
