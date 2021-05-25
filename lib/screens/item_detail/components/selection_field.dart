import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tour_log/common/bottom_sheet.dart';
import 'package:tour_log/models/field_model.dart';

class ItemDetailSelectionField extends StatelessWidget {
  final SelectionFieldModel selectionFieldModel;
  final Subject<FieldModel> updateSubject;

  ItemDetailSelectionField(this.selectionFieldModel, this.updateSubject);

  void _openOptionSelection(BuildContext context) {
    showDynamicHeightModalBottomSheet(
        context,
        (c) => _OptionSelectionBottomSheetContent(
            selectionFieldModel, updateSubject));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          child: Text(selectionFieldModel.spec.label),
        )),
        Expanded(
            child: Container(
                child: OutlinedButton.icon(
                    onPressed: () => _openOptionSelection(context),
                    icon: Icon(Icons.arrow_drop_down),
                    label: Text(selectionFieldModel.value)))),
      ],
    );
  }
}

class _OptionSelectionBottomSheetContent extends StatefulWidget {
  final SelectionFieldModel selectionFieldModel;
  final Subject<FieldModel> updateSubject;

  _OptionSelectionBottomSheetContent(
      this.selectionFieldModel, this.updateSubject);

  @override
  State createState() {
    return _OptionSelectionBottomSheetContentState(selectionFieldModel.value);
  }
}

class _OptionSelectionBottomSheetContentState
    extends State<_OptionSelectionBottomSheetContent> {
  static const String defaultOptionSearchValue = '';
  final _textController = TextEditingController();

  String _selectedValue;
  String optionSearchValue = defaultOptionSearchValue;

  _OptionSelectionBottomSheetContentState(this._selectedValue);

  @override
  Widget build(BuildContext context) {
    final columnContent = [
      Text(widget.selectionFieldModel.spec.label + " auswählen",
          style: Theme.of(context).textTheme.headline6),
      Flexible(
        child: ListView(
            shrinkWrap: true, children: _createSelectionOptionWidgetsList()),
      ),
    ];

    if (widget.selectionFieldModel.spec.allowOptionFiltering) {
      columnContent.add(TextField(
        controller: _textController,
        onChanged: (value) {
          setState(() {
            optionSearchValue = value;
          });
        },
        decoration: InputDecoration(
            suffixIcon: optionSearchValue.isEmpty
                ? Icon(Icons.search)
                : IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        optionSearchValue = defaultOptionSearchValue;
                      });
                      _textController.clear();
                    },
                  ),
            border: OutlineInputBorder(),
            hintText:
                '${widget.selectionFieldModel.spec.optionNamePlural} filtern'),
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: columnContent,
    );
  }

  List<ListTile> _createSelectionOptionWidgetsList() {
    final optionsList = widget.selectionFieldModel.spec.options
        .where((option) =>
            optionSearchValue.isEmpty || option.contains(optionSearchValue))
        .map((option) => ListTile(
            title: Text(
              option,
            ),
            onTap: () {
              setState(() {
                _selectedValue = option;
              });
              widget.updateSubject.add(widget.selectionFieldModel.copy(option));
              Navigator.pop(context);
            },
            trailing: _isSelectedOption(option) ? Icon(Icons.check) : null,
            selected: _isSelectedOption(option)))
        .toList();
    if (optionsList.isEmpty) {
      return [
        ListTile(
            title: Text(
                'Keine ${widget.selectionFieldModel.spec.optionNamePlural} gefunden',
                style: TextStyle(fontStyle: FontStyle.italic)))
      ];
    }
    return optionsList;
  }

  bool _isSelectedOption(String option) {
    return _selectedValue == option;
  }
}
