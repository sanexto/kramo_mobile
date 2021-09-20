import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:select_form_field/select_form_field.dart';

import '../../../utils/cancelable_task.dart';
import '../../../utils/pick_icon.dart';

import '../../../widgets/date_range_picker.dart';

class FilterParkingPage extends StatefulWidget {

  final Map<String, dynamic> ui;

  FilterParkingPage({Key? key, required this.ui}) : super(key: key);

  @override
  _FilterParkingPageState createState() => _FilterParkingPageState();

}

class _FilterParkingPageState extends State<FilterParkingPage> {

  final CancelableTask _cancelableTask = CancelableTask();
  Map<String, dynamic> _ui = {};

  @override
  void initState() {

    super.initState();

    this._initUi();

  }

  @override
  void dispose() {

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    Widget page = Scaffold(
      appBar: AppBar(
        title: Text(
          this._ui['title'],
        ),
        actions: [
          Flexible(
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: TextButton(
                  child: Text(
                    this._ui['actionMenu']['item']['clearFilter']['title'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryTextTheme.headline6!.color,
                  ),
                  onPressed: () => this._clearFilter(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              TextField(
                                focusNode: this._ui['form']['filterParking']['field']['entry']['focusNode'],
                                controller: this._ui['form']['filterParking']['field']['entry']['controller'],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    left: 12.0,
                                    top: 12.0,
                                    right: 48.0,
                                    bottom: 12.0,
                                  ),
                                  labelText: this._ui['form']['filterParking']['field']['entry']['label'],
                                  hintText: this._ui['form']['filterParking']['field']['entry']['hint'],
                                  filled: true,
                                ),
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                onTap: () => this._cancelableTask.run('_openEntryDateRangePickerDialog', this._openEntryDateRangePickerDialog(context)),
                                onEditingComplete: () => this._ui['form']['filterParking']['field']['exit']['focusNode'].requestFocus(),
                              ),
                              this._ui['form']['filterParking']['field']['entry']['dateTimeRangeValue'].value == this._ui['form']['filterParking']['field']['entry']['default'] ? SizedBox.shrink() : Padding(
                                padding: EdgeInsets.only(
                                  top: 6.0,
                                ),
                                child: IconButton(
                                  icon: FaIcon(
                                    pickIcon('times'),
                                  ),
                                  color: Colors.black45,
                                  onPressed: () => this._clearEntryFilter(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              TextField(
                                focusNode: this._ui['form']['filterParking']['field']['exit']['focusNode'],
                                controller: this._ui['form']['filterParking']['field']['exit']['controller'],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    left: 12.0,
                                    top: 12.0,
                                    right: 48.0,
                                    bottom: 12.0,
                                  ),
                                  labelText: this._ui['form']['filterParking']['field']['exit']['label'],
                                  hintText: this._ui['form']['filterParking']['field']['exit']['hint'],
                                  filled: true,
                                ),
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                onTap: () => this._cancelableTask.run('_openExitDateRangePickerDialog', this._openExitDateRangePickerDialog(context)),
                                onEditingComplete: () => this._ui['form']['filterParking']['field']['orderBy']['focusNode'].requestFocus(),
                              ),
                              this._ui['form']['filterParking']['field']['exit']['dateTimeRangeValue'].value == this._ui['form']['filterParking']['field']['exit']['default'] ? SizedBox.shrink() : Padding(
                                padding: EdgeInsets.only(
                                  top: 6.0,
                                ),
                                child: IconButton(
                                  icon: FaIcon(
                                    pickIcon('times'),
                                  ),
                                  color: Colors.black45,
                                  onPressed: () => this._clearExitFilter(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              SelectFormField(
                                focusNode: this._ui['form']['filterParking']['field']['orderBy']['focusNode'],
                                controller: this._ui['form']['filterParking']['field']['orderBy']['controller'],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    left: 12.0,
                                    top: 12.0,
                                    right: 48.0,
                                    bottom: 12.0,
                                  ),
                                  labelText: this._ui['form']['filterParking']['field']['orderBy']['label'],
                                  hintText: this._ui['form']['filterParking']['field']['orderBy']['hint'],
                                  filled: true,
                                ),
                                items: this._ui['form']['filterParking']['field']['orderBy']['item'].isEmpty ? [{'label': '', 'value': ''}] : this._ui['form']['filterParking']['field']['orderBy']['item'].map<Map<String, dynamic>>((Map<String, dynamic> item) {

                                  return {
                                    'label': item['label'],
                                    'value': item['value'],
                                  };

                                }).toList(),
                                textInputAction: TextInputAction.next,
                                onChanged: (String value) => this.setState(() {}),
                                onEditingComplete: () => this._ui['form']['filterParking']['field']['order']['focusNode'].requestFocus(),
                              ),
                              this._ui['form']['filterParking']['field']['orderBy']['controller'].text == this._ui['form']['filterParking']['field']['orderBy']['default'] ? SizedBox.shrink() : Padding(
                                padding: EdgeInsets.only(
                                  top: 6.0,
                                ),
                                child: IconButton(
                                  icon: FaIcon(
                                    pickIcon('times'),
                                  ),
                                  color: Colors.black45,
                                  onPressed: () => this._clearOrderByFilter(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              SelectFormField(
                                focusNode: this._ui['form']['filterParking']['field']['order']['focusNode'],
                                controller: this._ui['form']['filterParking']['field']['order']['controller'],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    left: 12.0,
                                    top: 12.0,
                                    right: 48.0,
                                    bottom: 12.0,
                                  ),
                                  labelText: this._ui['form']['filterParking']['field']['order']['label'],
                                  hintText: this._ui['form']['filterParking']['field']['order']['hint'],
                                  filled: true,
                                ),
                                items: this._ui['form']['filterParking']['field']['order']['item'].isEmpty ? [{'label': '', 'value': ''}] : this._ui['form']['filterParking']['field']['order']['item'].map<Map<String, dynamic>>((Map<String, dynamic> item) {

                                  return {
                                    'label': item['label'],
                                    'value': item['value'],
                                  };

                                }).toList(),
                                textInputAction: TextInputAction.done,
                                onChanged: (String value) => this.setState(() {}),
                              ),
                              this._ui['form']['filterParking']['field']['order']['controller'].text == this._ui['form']['filterParking']['field']['order']['default'] ? SizedBox.shrink() : Padding(
                                padding: EdgeInsets.only(
                                  top: 6.0,
                                ),
                                child: IconButton(
                                  icon: FaIcon(
                                    pickIcon('times'),
                                  ),
                                  color: Colors.black45,
                                  onPressed: () => this._clearOrderFilter(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.maxFinite,
              height: Theme.of(context).primaryTextTheme.headline2!.fontSize,
              child: ElevatedButton(
                child: Text(
                  this._ui['form']['filterParking']['button']['apply']['label'],
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
          ),
        ],
      ),
    );

    return page;

  }

  void _initUi() {

    this._ui = this.widget.ui;

  }

  Future<void> _openEntryDateRangePickerDialog(BuildContext context) async {

    final DateTimeRange? pickedDateRange = await DateRangePicker.show(
      context: context,
      initialDateRange: this._ui['form']['filterParking']['field']['entry']['dateTimeRangeValue'].dateTimeRange,
      fieldHintText: this._ui['form']['filterParking']['field']['entry']['pickerHint'],
    );

    if (pickedDateRange != null) {

      this._ui['form']['filterParking']['field']['entry']['dateTimeRangeValue'].dateTimeRange = pickedDateRange;
      this._ui['form']['filterParking']['field']['entry']['controller'].text = this._ui['form']['filterParking']['field']['entry']['dateTimeRangeValue'].mask;

      this.setState(() {});

    }

  }

  Future<void> _openExitDateRangePickerDialog(BuildContext context) async {

    final DateTimeRange? pickedDateRange = await DateRangePicker.show(
      context: context,
      initialDateRange: this._ui['form']['filterParking']['field']['exit']['dateTimeRangeValue'].dateTimeRange,
      fieldHintText: this._ui['form']['filterParking']['field']['exit']['pickerHint'],
    );

    if (pickedDateRange != null) {

      this._ui['form']['filterParking']['field']['exit']['dateTimeRangeValue'].dateTimeRange = pickedDateRange;
      this._ui['form']['filterParking']['field']['exit']['controller'].text = this._ui['form']['filterParking']['field']['exit']['dateTimeRangeValue'].mask;

      this.setState(() {});

    }

  }

  void _clearFilter() {

    this._ui['form']['filterParking']['field']['entry']['dateTimeRangeValue'].value = this._ui['form']['filterParking']['field']['entry']['default'];
    this._ui['form']['filterParking']['field']['entry']['controller'].text = this._ui['form']['filterParking']['field']['entry']['dateTimeRangeValue'].mask;
    this._ui['form']['filterParking']['field']['exit']['dateTimeRangeValue'].value = this._ui['form']['filterParking']['field']['exit']['default'];
    this._ui['form']['filterParking']['field']['exit']['controller'].text = this._ui['form']['filterParking']['field']['exit']['dateTimeRangeValue'].mask;
    this._ui['form']['filterParking']['field']['orderBy']['controller'].text = this._ui['form']['filterParking']['field']['orderBy']['default'];
    this._ui['form']['filterParking']['field']['order']['controller'].text = this._ui['form']['filterParking']['field']['order']['default'];

    this.setState(() {});

  }

  void _clearEntryFilter() {

    this._ui['form']['filterParking']['field']['entry']['dateTimeRangeValue'].value = this._ui['form']['filterParking']['field']['entry']['default'];
    this._ui['form']['filterParking']['field']['entry']['controller'].text = this._ui['form']['filterParking']['field']['entry']['dateTimeRangeValue'].mask;

    this.setState(() {});

  }

  void _clearExitFilter() {

    this._ui['form']['filterParking']['field']['exit']['dateTimeRangeValue'].value = this._ui['form']['filterParking']['field']['exit']['default'];
    this._ui['form']['filterParking']['field']['exit']['controller'].text = this._ui['form']['filterParking']['field']['exit']['dateTimeRangeValue'].mask;

    this.setState(() {});

  }

  void _clearOrderByFilter() {

    this._ui['form']['filterParking']['field']['orderBy']['controller'].text = this._ui['form']['filterParking']['field']['orderBy']['default'];

    this.setState(() {});

  }

  void _clearOrderFilter() {

    this._ui['form']['filterParking']['field']['order']['controller'].text = this._ui['form']['filterParking']['field']['order']['default'];

    this.setState(() {});

  }

}
