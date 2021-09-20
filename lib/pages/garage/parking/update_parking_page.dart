import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../api/api.dart' as api;
import '../../../api/req/req.dart' as req;
import '../../../api/res/res.dart' as res;

import '../../../helpers/date_time_value.dart';

import '../../../utils/cancelable_task.dart';
import '../../../utils/deep_map.dart';
import '../../../utils/pick_icon.dart';

import '../../../widgets/error_box.dart';
import '../../../widgets/date_picker.dart';
import '../../../widgets/time_picker.dart';

import '../auth/login_page.dart';

class UpdateParkingPage extends StatefulWidget {

  final int parkingId;

  UpdateParkingPage({Key? key, required this.parkingId}) : super(key: key);

  @override
  _UpdateParkingPageState createState() => _UpdateParkingPageState();

}

class _UpdateParkingPageState extends State<UpdateParkingPage> {

  final CancelableTask _cancelableTask = CancelableTask();
  Map<String, dynamic> _ui = {};

  @override
  void initState() {

    super.initState();

    this._cancelableTask.run('_initUi', this._initUi());

  }

  @override
  void dispose() {

    this._disposeUi();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    Widget page = Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (this._ui.isNotEmpty) {

      if (this._ui.containsKey('error')) {

        page = Scaffold(
          appBar: AppBar(),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: ErrorBox(
                    message: this._ui['error']['message'],
                    onRetry: () => this._retry(),
                  ),
                ),
              );
            },
          ),
        );

      } else {

        page = Scaffold(
          appBar: AppBar(
            title: Text(
              this._ui['title'],
            ),
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
                              TextField(
                                focusNode: this._ui['form']['updateParking']['field']['plate']['focusNode'],
                                controller: this._ui['form']['updateParking']['field']['plate']['controller'],
                                decoration: InputDecoration(
                                  labelText: this._ui['form']['updateParking']['field']['plate']['label'],
                                  hintText: this._ui['form']['updateParking']['field']['plate']['hint'],
                                  errorText: this._ui['form']['updateParking']['field']['plate']['error'],
                                  errorMaxLines: 100,
                                  filled: true,
                                ),
                                textCapitalization: TextCapitalization.characters,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['focusNode'].requestFocus(),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                this._ui['form']['updateParking']['fieldSet']['entry']['label'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.caption!.color,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                focusNode: this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['focusNode'],
                                controller: this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['controller'],
                                decoration: InputDecoration(
                                  labelText: this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['label'],
                                  hintText: this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['hint'],
                                  errorText: this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['error'],
                                  errorMaxLines: 100,
                                  filled: true,
                                ),
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                onTap: () => this._cancelableTask.run('_openEntryDatePickerDialog', this._openEntryDatePickerDialog(context)),
                                onEditingComplete: () => this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['focusNode'].requestFocus(),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                focusNode: this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['focusNode'],
                                controller: this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['controller'],
                                decoration: InputDecoration(
                                  labelText: this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['label'],
                                  hintText: this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['hint'],
                                  errorText: this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['error'],
                                  errorMaxLines: 100,
                                  filled: true,
                                ),
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                onTap: () => this._cancelableTask.run('_openEntryTimePickerDialog', this._openEntryTimePickerDialog(context)),
                                onEditingComplete: () => this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['focusNode'].requestFocus(),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                this._ui['form']['updateParking']['fieldSet']['exit']['label'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.caption!.color,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  TextField(
                                    focusNode: this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['focusNode'],
                                    controller: this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['controller'],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: 12.0,
                                        top: 12.0,
                                        right: 48.0,
                                        bottom: 12.0,
                                      ),
                                      labelText: this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['label'],
                                      hintText: this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['hint'],
                                      errorText: this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['error'],
                                      errorMaxLines: 100,
                                      filled: true,
                                    ),
                                    readOnly: true,
                                    textInputAction: TextInputAction.next,
                                    onTap: () => this._cancelableTask.run('_openExitDatePickerDialog', this._openExitDatePickerDialog(context)),
                                    onEditingComplete: () => this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['focusNode'].requestFocus(),
                                  ),
                                  this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].value.isEmpty ? SizedBox.shrink() : Padding(
                                    padding: EdgeInsets.only(
                                      top: 6.0,
                                    ),
                                    child: IconButton(
                                      icon: FaIcon(
                                        pickIcon('times'),
                                      ),
                                      color: Colors.black45,
                                      onPressed: () => this._clearExitDate(),
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
                                    focusNode: this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['focusNode'],
                                    controller: this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['controller'],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: 12.0,
                                        top: 12.0,
                                        right: 48.0,
                                        bottom: 12.0,
                                      ),
                                      labelText: this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['label'],
                                      hintText: this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['hint'],
                                      errorText: this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['error'],
                                      errorMaxLines: 100,
                                      filled: true,
                                    ),
                                    readOnly: true,
                                    textInputAction: TextInputAction.done,
                                    onTap: () => this._cancelableTask.run('_openExitTimePickerDialog', this._openExitTimePickerDialog(context)),
                                  ),
                                  this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].value.isEmpty ? SizedBox.shrink() : Padding(
                                    padding: EdgeInsets.only(
                                      top: 6.0,
                                    ),
                                    child: IconButton(
                                      icon: FaIcon(
                                        pickIcon('times'),
                                      ),
                                      color: Colors.black45,
                                      onPressed: () => this._clearExitTime(),
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
                      this._ui['form']['updateParking']['button']['update']['label'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: !this._ui['form']['updateParking']['button']['update']['enabled'] ? null : () => this._cancelableTask.run('_updateParking', this._updateParking(context)),
                  ),
                ),
              ),
            ],
          ),
        );

      }

    }

    return page;

  }

  Future<void> _initUi() async {

    final req.Request request = req.Request('get', '/garage/parking/update/${this.widget.parkingId}');

    final res.Response response = await api.send(request);

    switch (response.status) {

      case res.Status.FailedConnection:
      case res.Status.ServerError:
      case res.Status.BadResponse:
      case res.Status.BadRequest:
      case res.Status.Forbidden: {

        this._ui = {
          'error': {
            'message': DeepMap(response.body).getString('message') ?? '',
          },
        };

        break;

      }
      case res.Status.Unauthorized: {

        Navigator.pushAndRemoveUntil(
          this.context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return LoginPage();
            },
          ),
          (Route<dynamic> route) => false,
        );

        break;

      }
      case res.Status.Ok: {

        final int state = DeepMap(response.body).getInt('state') ?? 0;

        switch (state) {

          case 1: {

            this._ui = {
              'error': {
                'message': DeepMap(response.body).getString('error.message') ?? '',
              },
            };

            break;

          }
          case 2: {

            this._ui = {
              'title': DeepMap(response.body).getString('title') ?? '',
              'form': {
                'updateParking': {
                  'field': {
                    'plate': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'label': DeepMap(response.body).getString('form.updateParking.field.plate.label') ?? '',
                      'hint': DeepMap(response.body).getString('form.updateParking.field.plate.hint') ?? '',
                      'error': null,
                    },
                  },
                  'fieldSet': {
                    'entry': {
                      'label': DeepMap(response.body).getString('form.updateParking.fieldSet.entry.label') ?? '',
                      'field': {
                        'date': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('form.updateParking.fieldSet.entry.field.date.label') ?? '',
                          'hint': DeepMap(response.body).getString('form.updateParking.fieldSet.entry.field.date.hint') ?? '',
                          'error': null,
                          'dateTimeValue': DateTimeValue(
                            valueFormat: 'yyyy/M/d',
                            maskFormat: 'E d \'de\' MMM \'del\' yyyy',
                            maskLocale: Localizations.localeOf(this.context).languageCode,
                          ),
                          'pickerHint': DeepMap(response.body).getString('form.updateParking.fieldSet.entry.field.date.pickerHint') ?? '',
                        },
                        'time': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('form.updateParking.fieldSet.entry.field.time.label') ?? '',
                          'hint': DeepMap(response.body).getString('form.updateParking.fieldSet.entry.field.time.hint') ?? '',
                          'error': null,
                          'dateTimeValue': DateTimeValue(
                            valueFormat: 'H:m',
                            maskFormat: 'HH:mm',
                            maskLocale: Localizations.localeOf(this.context).languageCode,
                          ),
                          'pickerHint': DeepMap(response.body).getString('form.updateParking.fieldSet.entry.field.time.pickerHint') ?? '',
                        },
                      },
                    },
                    'exit': {
                      'label': DeepMap(response.body).getString('form.updateParking.fieldSet.exit.label') ?? '',
                      'field': {
                        'date': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('form.updateParking.fieldSet.exit.field.date.label') ?? '',
                          'hint': DeepMap(response.body).getString('form.updateParking.fieldSet.exit.field.date.hint') ?? '',
                          'error': null,
                          'dateTimeValue': DateTimeValue(
                            valueFormat: 'yyyy/M/d',
                            maskFormat: 'E d \'de\' MMM \'del\' yyyy',
                            maskLocale: Localizations.localeOf(this.context).languageCode,
                          ),
                          'pickerHint': DeepMap(response.body).getString('form.updateParking.fieldSet.exit.field.date.pickerHint') ?? '',
                        },
                        'time': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('form.updateParking.fieldSet.exit.field.time.label') ?? '',
                          'hint': DeepMap(response.body).getString('form.updateParking.fieldSet.exit.field.time.hint') ?? '',
                          'error': null,
                          'dateTimeValue': DateTimeValue(
                            valueFormat: 'H:m',
                            maskFormat: 'HH:mm',
                            maskLocale: Localizations.localeOf(this.context).languageCode,
                          ),
                          'pickerHint': DeepMap(response.body).getString('form.updateParking.fieldSet.exit.field.time.pickerHint') ?? '',
                        },
                      },
                    },
                  },
                  'button': {
                    'update': {
                      'label': DeepMap(response.body).getString('form.updateParking.button.update.label') ?? '',
                      'enabled': true,
                    },
                  },
                },
              },
            };

            this._ui['form']['updateParking']['field']['plate']['controller'].text = DeepMap(response.body).getString('form.updateParking.field.plate.value') ?? '';
            this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['dateTimeValue'].value = DeepMap(response.body).getString('form.updateParking.fieldSet.entry.field.date.value') ?? '';
            this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['controller'].text = this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['dateTimeValue'].mask;
            this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['dateTimeValue'].value = DeepMap(response.body).getString('form.updateParking.fieldSet.entry.field.time.value') ?? '';
            this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['controller'].text = this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['dateTimeValue'].mask;
            this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].value = DeepMap(response.body).getString('form.updateParking.fieldSet.exit.field.date.value') ?? '';
            this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['controller'].text = this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].mask;
            this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].value = DeepMap(response.body).getString('form.updateParking.fieldSet.exit.field.time.value') ?? '';
            this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['controller'].text = this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].mask;

            break;

          }

        }

        break;

      }

    }

    this.setState(() {});

  }

  void _disposeUi() {

    this._cancelableTask.cancel();

    DeepMap(this._ui).getValue('form.updateParking.field.plate.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.updateParking.fieldSet.entry.field.date.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.updateParking.fieldSet.entry.field.time.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.updateParking.fieldSet.exit.field.date.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.updateParking.fieldSet.exit.field.time.focusNode')?.dispose();

    DeepMap(this._ui).getValue('form.updateParking.field.plate.controller')?.dispose();
    DeepMap(this._ui).getValue('form.updateParking.fieldSet.entry.field.date.controller')?.dispose();
    DeepMap(this._ui).getValue('form.updateParking.fieldSet.entry.field.time.controller')?.dispose();
    DeepMap(this._ui).getValue('form.updateParking.fieldSet.exit.field.date.controller')?.dispose();
    DeepMap(this._ui).getValue('form.updateParking.fieldSet.exit.field.time.controller')?.dispose();

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

  Future<void> _openEntryDatePickerDialog(BuildContext context) async {

    final DateTime? pickedDate = await DatePicker.show(
      context: context,
      initialDate: this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['dateTimeValue'].dateTime,
      fieldHintText: this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['pickerHint'],
    );

    if (pickedDate != null) {

      this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['dateTimeValue'].dateTime = pickedDate;
      this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['controller'].text = this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['dateTimeValue'].mask;

    }

  }

  Future<void> _openEntryTimePickerDialog(BuildContext context) async {

    final DateTime? pickedTime = await TimePicker.show(
      context: context,
      initialTime: this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['dateTimeValue'].dateTime,
    );

    if (pickedTime != null) {

      this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['dateTimeValue'].dateTime = pickedTime;
      this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['controller'].text = this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['dateTimeValue'].mask;

    }

  }

  Future<void> _openExitDatePickerDialog(BuildContext context) async {

    final DateTime? pickedDate = await DatePicker.show(
      context: context,
      initialDate: this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].dateTime,
      fieldHintText: this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['pickerHint'],
    );

    if (pickedDate != null) {

      this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].dateTime = pickedDate;
      this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['controller'].text = this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].mask;

      this.setState(() {});

    }

  }

  Future<void> _openExitTimePickerDialog(BuildContext context) async {

    final DateTime? pickedTime = await TimePicker.show(
      context: context,
      initialTime: this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].dateTime,
    );

    if (pickedTime != null) {

      this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].dateTime = pickedTime;
      this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['controller'].text = this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].mask;

      this.setState(() {});

    }

  }

  void _clearExitDate() {

    this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].value = '';
    this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['controller'].text = this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].mask;

    this.setState(() {});

  }

  void _clearExitTime() {

    this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].value = '';
    this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['controller'].text = this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].mask;

    this.setState(() {});

  }

  Future<void> _updateParking(BuildContext context) async {

    this._ui['form']['updateParking']['button']['update']['enabled'] = false;
    this._ui['form']['updateParking']['field']['plate']['error'] = null;
    this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['error'] = null;
    this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['error'] = null;
    this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['error'] = null;
    this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['error'] = null;

    this.setState(() {});

    final req.Request request = req.Request('put', '/garage/parking/update/${this.widget.parkingId}');

    request.bodyFields = {
      'plate': this._ui['form']['updateParking']['field']['plate']['controller'].text,
      'entryDate': this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['dateTimeValue'].value,
      'entryTime': this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['dateTimeValue'].value,
      'exitDate': this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['dateTimeValue'].value,
      'exitTime': this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['dateTimeValue'].value,
    };

    final res.Response response = await api.send(request);

    switch (response.status) {

      case res.Status.FailedConnection:
      case res.Status.ServerError:
      case res.Status.BadResponse:
      case res.Status.BadRequest:
      case res.Status.Forbidden: {

        final String message = DeepMap(response.body).getString('message') ?? '';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
            ),
          ),
        );

        break;

      }
      case res.Status.Unauthorized: {

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return LoginPage();
            },
          ),
          (Route<dynamic> route) => false,
        );

        break;

      }
      case res.Status.Ok: {

        final int state = DeepMap(response.body).getInt('state') ?? 0;
        final String message = DeepMap(response.body).getString('message') ?? '';
        final Map<String, dynamic> field = DeepMap(response.body).getMap('field');

        switch (state) {

          case 1: {

            this._ui['form']['updateParking']['field']['plate']['error'] = DeepMap(field).getString('plate.message');
            this._ui['form']['updateParking']['fieldSet']['entry']['field']['date']['error'] = DeepMap(field).getString('entryDate.message');
            this._ui['form']['updateParking']['fieldSet']['entry']['field']['time']['error'] = DeepMap(field).getString('entryTime.message');
            this._ui['form']['updateParking']['fieldSet']['exit']['field']['date']['error'] = DeepMap(field).getString('exitDate.message');
            this._ui['form']['updateParking']['fieldSet']['exit']['field']['time']['error'] = DeepMap(field).getString('exitTime.message');

            break;

          }
          case 2: {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  message,
                ),
              ),
            );

            break;

          }
          case 3: {

            Navigator.pop(context, true);

            break;

          }

        }

        break;

      }

    }

    this._ui['form']['updateParking']['button']['update']['enabled'] = true;

    this.setState(() {});

  }

}
