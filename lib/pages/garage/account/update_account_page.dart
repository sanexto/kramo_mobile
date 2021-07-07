import 'package:flutter/material.dart';

import '../../../api/api.dart' as api;
import '../../../api/req/req.dart' as req;
import '../../../api/res/res.dart' as res;

import '../../../utils/cancelable_task.dart';
import '../../../utils/deep_map.dart';

import '../../../widgets/error_box.dart';

import '../auth/login_page.dart';

class UpdateAccountPage extends StatefulWidget {

  UpdateAccountPage({Key? key}) : super(key: key);

  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();

}

class _UpdateAccountPageState extends State<UpdateAccountPage> {

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
                                focusNode: this._ui['form']['updateAccount']['field']['name']['focusNode'],
                                controller: this._ui['form']['updateAccount']['field']['name']['controller'],
                                decoration: InputDecoration(
                                  labelText: this._ui['form']['updateAccount']['field']['name']['label'],
                                  hintText: this._ui['form']['updateAccount']['field']['name']['hint'],
                                  errorText: this._ui['form']['updateAccount']['field']['name']['error'],
                                  errorMaxLines: 100,
                                  filled: true,
                                ),
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => this._ui['form']['updateAccount']['field']['email']['focusNode'].requestFocus(),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                focusNode: this._ui['form']['updateAccount']['field']['email']['focusNode'],
                                controller: this._ui['form']['updateAccount']['field']['email']['controller'],
                                decoration: InputDecoration(
                                  labelText: this._ui['form']['updateAccount']['field']['email']['label'],
                                  hintText: this._ui['form']['updateAccount']['field']['email']['hint'],
                                  errorText: this._ui['form']['updateAccount']['field']['email']['error'],
                                  errorMaxLines: 100,
                                  filled: true,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => this._ui['form']['updateAccount']['field']['username']['focusNode'].requestFocus(),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                focusNode: this._ui['form']['updateAccount']['field']['username']['focusNode'],
                                controller: this._ui['form']['updateAccount']['field']['username']['controller'],
                                decoration: InputDecoration(
                                  labelText: this._ui['form']['updateAccount']['field']['username']['label'],
                                  hintText: this._ui['form']['updateAccount']['field']['username']['hint'],
                                  errorText: this._ui['form']['updateAccount']['field']['username']['error'],
                                  errorMaxLines: 100,
                                  filled: true,
                                ),
                                textInputAction: TextInputAction.done,
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
                      this._ui['form']['updateAccount']['button']['update']['label'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: !this._ui['form']['updateAccount']['button']['update']['enabled'] ? null : () => this._cancelableTask.run('_updateAccount', this._updateAccount(context)),
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

    final req.Request request = req.Request('get', '/garage/account/update');

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
                'updateAccount': {
                  'field': {
                    'name': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'label': DeepMap(response.body).getString('form.updateAccount.field.name.label') ?? '',
                      'hint': DeepMap(response.body).getString('form.updateAccount.field.name.hint') ?? '',
                      'error': null,
                    },
                    'email': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'label': DeepMap(response.body).getString('form.updateAccount.field.email.label') ?? '',
                      'hint': DeepMap(response.body).getString('form.updateAccount.field.email.hint') ?? '',
                      'error': null,
                    },
                    'username': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'label': DeepMap(response.body).getString('form.updateAccount.field.username.label') ?? '',
                      'hint': DeepMap(response.body).getString('form.updateAccount.field.username.hint') ?? '',
                      'error': null,
                    },
                  },
                  'button': {
                    'update': {
                      'label': DeepMap(response.body).getString('form.updateAccount.button.update.label') ?? '',
                      'enabled': true,
                    },
                  },
                },
              },
            };

            this._ui['form']['updateAccount']['field']['name']['controller'].text = DeepMap(response.body).getString('form.updateAccount.field.name.value') ?? '';
            this._ui['form']['updateAccount']['field']['email']['controller'].text = DeepMap(response.body).getString('form.updateAccount.field.email.value') ?? '';
            this._ui['form']['updateAccount']['field']['username']['controller'].text = DeepMap(response.body).getString('form.updateAccount.field.username.value') ?? '';

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

    DeepMap(this._ui).getValue('form.updateAccount.field.name.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.updateAccount.field.email.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.updateAccount.field.username.focusNode')?.dispose();

    DeepMap(this._ui).getValue('form.updateAccount.field.name.controller')?.dispose();
    DeepMap(this._ui).getValue('form.updateAccount.field.email.controller')?.dispose();
    DeepMap(this._ui).getValue('form.updateAccount.field.username.controller')?.dispose();

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

  Future<void> _updateAccount(BuildContext context) async {

    this._ui['form']['updateAccount']['button']['update']['enabled'] = false;
    this._ui['form']['updateAccount']['field']['name']['error'] = null;
    this._ui['form']['updateAccount']['field']['email']['error'] = null;
    this._ui['form']['updateAccount']['field']['username']['error'] = null;

    this.setState(() {});

    final req.Request request = req.Request('put', '/garage/account/update');

    request.bodyFields = {
      'name': this._ui['form']['updateAccount']['field']['name']['controller'].text,
      'email': this._ui['form']['updateAccount']['field']['email']['controller'].text,
      'username': this._ui['form']['updateAccount']['field']['username']['controller'].text,
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

            this._ui['form']['updateAccount']['field']['name']['error'] =  DeepMap(field).getString('name.message');
            this._ui['form']['updateAccount']['field']['email']['error'] = DeepMap(field).getString('email.message');
            this._ui['form']['updateAccount']['field']['username']['error'] = DeepMap(field).getString('username.message');

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

            final Map<String, dynamic> garageAccount = DeepMap(response.body).getMap('garageAccount');

            Navigator.pop(context, garageAccount);

            break;

          }

        }

        break;

      }

    }

    this._ui['form']['updateAccount']['button']['update']['enabled'] = true;

    this.setState(() {});

  }

}
