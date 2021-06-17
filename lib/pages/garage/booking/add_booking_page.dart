import 'package:flutter/material.dart';

import '../../../api/api.dart' as api;
import '../../../api/req/req.dart' as req;
import '../../../api/res/res.dart' as res;

import '../../../helpers/date_time_value.dart';

import '../../../utils/cancelable_task.dart';
import '../../../utils/deep_map.dart';

import '../../../widgets/error_box.dart';
import '../../../widgets/date_picker.dart';
import '../../../widgets/time_picker.dart';

import '../../auth/login_page.dart';

class AddBookingPage extends StatefulWidget {

  AddBookingPage({Key? key}) : super(key: key);

  @override
  _AddBookingPageState createState() => _AddBookingPageState();

}

class _AddBookingPageState extends State<AddBookingPage> {

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
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          autofocus: true,
                          focusNode: this._ui['form']['addBooking']['field']['vehiclePlate']['focusNode'],
                          controller: this._ui['form']['addBooking']['field']['vehiclePlate']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['addBooking']['field']['vehiclePlate']['label'],
                            hintText: this._ui['form']['addBooking']['field']['vehiclePlate']['hint'],
                            errorText: this._ui['form']['addBooking']['field']['vehiclePlate']['error'],
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['label'],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption!.color,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['focusNode'],
                          controller: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['label'],
                            hintText: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['hint'],
                            errorText: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['error'],
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          onTap: () => this._cancelableTask.run('_openVehicleEntryDatePickerDialog', this._openVehicleEntryDatePickerDialog(context)),
                          onEditingComplete: () => this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['focusNode'],
                          controller: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['label'],
                            hintText: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['hint'],
                            errorText: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['error'],
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          onTap: () => this._cancelableTask.run('_openVehicleEntryTimePickerDialog', this._openVehicleEntryTimePickerDialog(context)),
                          onEditingComplete: () => this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          this._ui['form']['addBooking']['fieldSet']['vehicleExit']['label'],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption!.color,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['focusNode'],
                          controller: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['label'],
                            hintText: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['hint'],
                            errorText: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['error'],
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          onTap: () => this._cancelableTask.run('_openVehicleExitDatePickerDialog', this._openVehicleExitDatePickerDialog(context)),
                          onEditingComplete: () => this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['focusNode'],
                          controller: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['label'],
                            hintText: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['hint'],
                            errorText: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['error'],
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          readOnly: true,
                          textInputAction: TextInputAction.done,
                          onTap: () => this._cancelableTask.run('_openVehicleExitTimePickerDialog', this._openVehicleExitTimePickerDialog(context)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  height: Theme.of(context).primaryTextTheme.headline2!.fontSize,
                  child: ElevatedButton(
                    child: Text(
                      this._ui['form']['addBooking']['button']['add']['label'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: !this._ui['form']['addBooking']['button']['add']['enabled'] ? null : () => this._cancelableTask.run('_addBooking', this._addBooking(context)),
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

    final req.Request request = req.Request('get', '/garage/booking/add');

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

        this._ui = {
          'title': DeepMap(response.body).getString('title') ?? '',
          'form': {
            'addBooking': {
              'field': {
                'vehiclePlate': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.addBooking.field.vehiclePlate.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.addBooking.field.vehiclePlate.hint') ?? '',
                  'error': null,
                },
              },
              'fieldSet': {
                'vehicleEntry': {
                  'label': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.label') ?? '',
                  'field': {
                    'date': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'label': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.field.date.label') ?? '',
                      'hint': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.field.date.hint') ?? '',
                      'pickerHint': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.field.date.pickerHint') ?? '',
                      'error': null,
                      'dateTimeValue': DateTimeValue(
                        valueFormat: 'yyyy/M/d',
                        maskFormat: 'E d \'de\' MMM \'del\' yyyy',
                        maskLocale: Localizations.localeOf(this.context).languageCode,
                      ),
                    },
                    'time': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'label': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.field.time.label') ?? '',
                      'hint': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.field.time.hint') ?? '',
                      'pickerHint': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.field.time.pickerHint') ?? '',
                      'error': null,
                      'dateTimeValue': DateTimeValue(
                        valueFormat: 'H:m',
                        maskFormat: 'H:mm',
                        maskLocale: Localizations.localeOf(this.context).languageCode,
                      ),
                    },
                  },
                },
                'vehicleExit': {
                  'label': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.label') ?? '',
                  'field': {
                    'date': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'label': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.field.date.label') ?? '',
                      'hint': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.field.date.hint') ?? '',
                      'pickerHint': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.field.date.pickerHint') ?? '',
                      'error': null,
                      'dateTimeValue': DateTimeValue(
                        valueFormat: 'yyyy/M/d',
                        maskFormat: 'E d \'de\' MMM \'del\' yyyy',
                        maskLocale: Localizations.localeOf(this.context).languageCode,
                      ),
                    },
                    'time': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'label': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.field.time.label') ?? '',
                      'hint': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.field.time.hint') ?? '',
                      'pickerHint': DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.field.time.pickerHint') ?? '',
                      'error': null,
                      'dateTimeValue': DateTimeValue(
                        valueFormat: 'H:m',
                        maskFormat: 'H:mm',
                        maskLocale: Localizations.localeOf(this.context).languageCode,
                      ),
                    },
                  },
                },
              },
              'button': {
                'add': {
                  'label': DeepMap(response.body).getString('form.addBooking.button.add.label') ?? '',
                  'enabled': true,
                },
              },
            },
          },
        };

        this._ui['form']['addBooking']['field']['vehiclePlate']['controller'].text = DeepMap(response.body).getString('form.addBooking.field.vehiclePlate.value') ?? '';
        this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['dateTimeValue'].value = DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.field.date.value') ?? '';
        this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['controller'].text = this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['dateTimeValue'].mask;
        this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['dateTimeValue'].value = DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleEntry.field.time.value') ?? '';
        this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['controller'].text = this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['dateTimeValue'].mask;
        this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['dateTimeValue'].value = DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.field.date.value') ?? '';
        this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['controller'].text = this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['dateTimeValue'].mask;
        this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['dateTimeValue'].value = DeepMap(response.body).getString('form.addBooking.fieldSet.vehicleExit.field.time.value') ?? '';
        this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['controller'].text = this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['dateTimeValue'].mask;

        break;

      }

    }

    this.setState(() {});

  }

  void _disposeUi() {

    this._cancelableTask.cancel();

    DeepMap(this._ui).getValue('form.addBooking.field.vehiclePlate.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.addBooking.fieldSet.vehicleEntry.field.date.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.addBooking.fieldSet.vehicleEntry.field.time.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.addBooking.fieldSet.vehicleExit.field.date.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.addBooking.fieldSet.vehicleExit.field.time.focusNode')?.dispose();

    DeepMap(this._ui).getValue('form.addBooking.field.vehiclePlate.controller')?.dispose();
    DeepMap(this._ui).getValue('form.addBooking.fieldSet.vehicleEntry.field.date.controller')?.dispose();
    DeepMap(this._ui).getValue('form.addBooking.fieldSet.vehicleEntry.field.time.controller')?.dispose();
    DeepMap(this._ui).getValue('form.addBooking.fieldSet.vehicleExit.field.date.controller')?.dispose();
    DeepMap(this._ui).getValue('form.addBooking.fieldSet.vehicleExit.field.time.controller')?.dispose();

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

  Future<void> _openVehicleEntryDatePickerDialog(BuildContext context) async {

    final DateTime? pickedDate = await DatePicker.show(
      context: context,
      initialDate: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['dateTimeValue'].dateTime,
      fieldHintText: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['pickerHint'],
    );

    if (pickedDate != null) {

      this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['dateTimeValue'].dateTime = pickedDate;
      this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['controller'].text = this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['dateTimeValue'].mask;

    }

  }

  Future<void> _openVehicleEntryTimePickerDialog(BuildContext context) async {

    final DateTime? pickedTime = await TimePicker.show(
      context: context,
      initialTime: this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['dateTimeValue'].dateTime,
    );

    if (pickedTime != null) {

      this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['dateTimeValue'].dateTime = pickedTime;
      this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['controller'].text = this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['dateTimeValue'].mask;

    }

  }

  Future<void> _openVehicleExitDatePickerDialog(BuildContext context) async {

    final DateTime? pickedDate = await DatePicker.show(
      context: context,
      initialDate: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['dateTimeValue'].dateTime,
      fieldHintText: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['pickerHint'],
    );

    if (pickedDate != null) {

      this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['dateTimeValue'].dateTime = pickedDate;
      this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['controller'].text = this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['dateTimeValue'].mask;

    }

  }

  Future<void> _openVehicleExitTimePickerDialog(BuildContext context) async {

    final DateTime? pickedTime = await TimePicker.show(
      context: context,
      initialTime: this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['dateTimeValue'].dateTime,
    );

    if (pickedTime != null) {

      this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['dateTimeValue'].dateTime = pickedTime;
      this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['controller'].text = this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['dateTimeValue'].mask;

    }

  }

  Future<void> _addBooking(BuildContext context) async {

    this._ui['form']['addBooking']['button']['add']['enabled'] = false;
    this._ui['form']['addBooking']['field']['vehiclePlate']['error'] = null;
    this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['error'] = null;
    this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['error'] = null;
    this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['error'] = null;
    this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['error'] = null;

    this.setState(() {});

    final req.Request request = req.Request('post', '/garage/booking/add');

    request.bodyFields = {
      'vehiclePlate': this._ui['form']['addBooking']['field']['vehiclePlate']['controller'].text,
      'vehicleEntryDate': this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['dateTimeValue'].value,
      'vehicleEntryTime': this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['dateTimeValue'].value,
      'vehicleExitDate': this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['dateTimeValue'].value,
      'vehicleExitTime': this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['dateTimeValue'].value,
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

            this._ui['form']['addBooking']['field']['vehiclePlate']['error'] = DeepMap(field).getString('vehiclePlate.message');
            this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['date']['error'] = DeepMap(field).getString('vehicleEntryDate.message');
            this._ui['form']['addBooking']['fieldSet']['vehicleEntry']['field']['time']['error'] = DeepMap(field).getString('vehicleEntryTime.message');
            this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['date']['error'] = DeepMap(field).getString('vehicleExitDate.message');
            this._ui['form']['addBooking']['fieldSet']['vehicleExit']['field']['time']['error'] = DeepMap(field).getString('vehicleExitTime.message');

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

    this._ui['form']['addBooking']['button']['add']['enabled'] = true;

    this.setState(() {});

  }

}
