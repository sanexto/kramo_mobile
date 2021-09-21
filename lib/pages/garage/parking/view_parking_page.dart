import 'package:flutter/material.dart';

import '../../../api/api.dart' as api;
import '../../../api/req/req.dart' as req;
import '../../../api/res/res.dart' as res;

import '../../../helpers/date_time_value.dart';

import '../../../utils/cancelable_task.dart';
import '../../../utils/deep_map.dart';

import '../../../widgets/error_box.dart';

import '../auth/login_page.dart';

class ViewParkingPage extends StatefulWidget {

  final int parkingId;

  ViewParkingPage({Key? key, required this.parkingId}) : super(key: key);

  @override
  _ViewParkingPageState createState() => _ViewParkingPageState();

}

class _ViewParkingPageState extends State<ViewParkingPage> {

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
                              Divider(
                                height: 16.0,
                                color: Colors.transparent,
                              ),
                              Text(
                                this._ui['parkingInfo']['parkingId']['label'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.headline1!.color,
                                ),
                              ),
                              Text(
                                this._ui['parkingInfo']['parkingId']['value'],
                              ),
                              Divider(
                                height: 32.0,
                              ),
                              Text(
                                this._ui['parkingInfo']['plate']['label'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.headline1!.color,
                                ),
                              ),
                              Text(
                                this._ui['parkingInfo']['plate']['value'],
                              ),
                              Divider(
                                height: 32.0,
                              ),
                              Text(
                                this._ui['parkingInfo']['entry']['label'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.headline1!.color,
                                ),
                              ),
                              Text(
                                this._ui['parkingInfo']['entry']['dateTimeValue'].mask,
                              ),
                              Divider(
                                height: 32.0,
                              ),
                              Text(
                                this._ui['parkingInfo']['exit']['label'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.headline1!.color,
                                ),
                              ),
                              Text(
                                this._ui['parkingInfo']['exit']['dateTimeValue'].mask,
                              ),
                              Divider(
                                height: 32.0,
                              ),
                              Text(
                                this._ui['parkingInfo']['price']['label'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.headline1!.color,
                                ),
                              ),
                              Text(
                                this._ui['parkingInfo']['price']['value'],
                              ),
                              Divider(
                                height: 16.0,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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

    final req.Request request = req.Request('get', '/garage/parking/list/${this.widget.parkingId}');

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
              'parkingInfo': {
                'parkingId': {
                  'label': DeepMap(response.body).getString('parkingInfo.parkingId.label') ?? '',
                  'value': DeepMap(response.body).getString('parkingInfo.parkingId.value') ?? '',
                },
                'plate': {
                  'label': DeepMap(response.body).getString('parkingInfo.plate.label') ?? '',
                  'value': DeepMap(response.body).getString('parkingInfo.plate.value') ?? '',
                },
                'entry': {
                  'label': DeepMap(response.body).getString('parkingInfo.entry.label') ?? '',
                  'dateTimeValue': DateTimeValue(
                    valueFormat: 'yyyy/M/d H:m',
                    maskFormat: 'E d \'de\' MMM \'del\' yyyy\',\' HH:mm \'hrs.\'',
                    maskLocale: Localizations.localeOf(this.context).languageCode,
                  ),
                },
                'exit': {
                  'label': DeepMap(response.body).getString('parkingInfo.exit.label') ?? '',
                  'dateTimeValue': DateTimeValue(
                    valueFormat: 'yyyy/M/d H:m',
                    maskFormat: 'E d \'de\' MMM \'del\' yyyy\',\' HH:mm \'hrs.\'',
                    maskLocale: Localizations.localeOf(this.context).languageCode,
                  ),
                },
                'price': {
                  'label': DeepMap(response.body).getString('parkingInfo.price.label') ?? '',
                  'value': DeepMap(response.body).getString('parkingInfo.price.value') ?? '',
                },
              },
            };

            this._ui['parkingInfo']['entry']['dateTimeValue'].value = DeepMap(response.body).getString('parkingInfo.entry.value') ?? '';
            this._ui['parkingInfo']['exit']['dateTimeValue'].value = DeepMap(response.body).getString('parkingInfo.exit.value') ?? '';

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
