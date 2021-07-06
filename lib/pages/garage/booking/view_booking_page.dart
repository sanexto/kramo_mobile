import 'package:flutter/material.dart';

import '../../../api/api.dart' as api;
import '../../../api/req/req.dart' as req;
import '../../../api/res/res.dart' as res;

import '../../../helpers/date_time_value.dart';

import '../../../utils/cancelable_task.dart';
import '../../../utils/deep_map.dart';

import '../../../widgets/error_box.dart';

import '../auth/login_page.dart';

class ViewBookingPage extends StatefulWidget {

  final int bookingId;

  ViewBookingPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _ViewBookingPageState createState() => _ViewBookingPageState();

}

class _ViewBookingPageState extends State<ViewBookingPage> {

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
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 16.0,
                          color: Colors.transparent,
                        ),
                        Text(
                          this._ui['bookingInfo']['bookingId']['label'],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        Text(
                          this._ui['bookingInfo']['bookingId']['value'],
                        ),
                        Divider(
                          height: 32.0,
                        ),
                        Text(
                          this._ui['bookingInfo']['vehiclePlate']['label'],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        Text(
                          this._ui['bookingInfo']['vehiclePlate']['value'],
                        ),
                        Divider(
                          height: 32.0,
                        ),
                        Text(
                          this._ui['bookingInfo']['vehicleEntry']['label'],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        Text(
                          this._ui['bookingInfo']['vehicleEntry']['dateTimeValue'].mask,
                        ),
                        Divider(
                          height: 32.0,
                        ),
                        Text(
                          this._ui['bookingInfo']['vehicleExit']['label'],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        Text(
                          this._ui['bookingInfo']['vehicleExit']['dateTimeValue'].mask,
                        ),
                        Divider(
                          height: 16.0,
                          color: Colors.transparent,
                        ),
                      ],
                    ),
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

    final req.Request request = req.Request('get', '/garage/booking/list/${this.widget.bookingId}');

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
              'bookingInfo': {
                'bookingId': {
                  'label': DeepMap(response.body).getString('bookingInfo.bookingId.label') ?? '',
                  'value': DeepMap(response.body).getString('bookingInfo.bookingId.value') ?? '',
                },
                'vehiclePlate': {
                  'label': DeepMap(response.body).getString('bookingInfo.vehiclePlate.label') ?? '',
                  'value': DeepMap(response.body).getString('bookingInfo.vehiclePlate.value') ?? '',
                },
                'vehicleEntry': {
                  'label': DeepMap(response.body).getString('bookingInfo.vehicleEntry.label') ?? '',
                  'dateTimeValue': DateTimeValue(
                    valueFormat: 'yyyy/M/d H:m',
                    maskFormat: 'E d \'de\' MMM \'del\' yyyy\',\' HH:mm \'hrs.\'',
                    maskLocale: Localizations.localeOf(this.context).languageCode,
                  ),
                },
                'vehicleExit': {
                  'label': DeepMap(response.body).getString('bookingInfo.vehicleExit.label') ?? '',
                  'dateTimeValue': DateTimeValue(
                    valueFormat: 'yyyy/M/d H:m',
                    maskFormat: 'E d \'de\' MMM \'del\' yyyy\',\' HH:mm \'hrs.\'',
                    maskLocale: Localizations.localeOf(this.context).languageCode,
                  ),
                },
              },
            };

            this._ui['bookingInfo']['vehicleEntry']['dateTimeValue'].value = DeepMap(response.body).getString('bookingInfo.vehicleEntry.value') ?? '';
            this._ui['bookingInfo']['vehicleExit']['dateTimeValue'].value = DeepMap(response.body).getString('bookingInfo.vehicleExit.value') ?? '';

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

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

}
