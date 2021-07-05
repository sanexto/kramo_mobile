import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../api/api.dart' as api;
import '../../../api/req/req.dart' as req;
import '../../../api/res/res.dart' as res;

import '../../../utils/cancelable_task.dart';
import '../../../utils/deep_map.dart';
import '../../../utils/pick_icon.dart';

import '../../../widgets/error_box.dart';

import '../auth/login_page.dart';

class UpdatePasswordPage extends StatefulWidget {

  UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();

}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {

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
                          focusNode: this._ui['form']['updatePassword']['field']['currentPassword']['focusNode'],
                          controller: this._ui['form']['updatePassword']['field']['currentPassword']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['updatePassword']['field']['currentPassword']['label'],
                            hintText: this._ui['form']['updatePassword']['field']['currentPassword']['hint'],
                            errorText: this._ui['form']['updatePassword']['field']['currentPassword']['error'],
                            suffixIcon: IconButton(
                              icon: FaIcon(
                                this._ui['form']['updatePassword']['field']['currentPassword']['reveal'] ? pickIcon('eye') : pickIcon('eye-slash'),
                              ),
                              onPressed: () {

                                this._ui['form']['updatePassword']['field']['currentPassword']['reveal'] = !this._ui['form']['updatePassword']['field']['currentPassword']['reveal'];

                                this.setState(() {});

                              },
                            ),
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          obscureText: !this._ui['form']['updatePassword']['field']['currentPassword']['reveal'],
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => this._ui['form']['updatePassword']['field']['newPassword']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['updatePassword']['field']['newPassword']['focusNode'],
                          controller: this._ui['form']['updatePassword']['field']['newPassword']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['updatePassword']['field']['newPassword']['label'],
                            hintText: this._ui['form']['updatePassword']['field']['newPassword']['hint'],
                            errorText: this._ui['form']['updatePassword']['field']['newPassword']['error'],
                            suffixIcon: IconButton(
                              icon: FaIcon(
                                this._ui['form']['updatePassword']['field']['newPassword']['reveal'] ? pickIcon('eye') : pickIcon('eye-slash'),
                              ),
                              onPressed: () {

                                this._ui['form']['updatePassword']['field']['newPassword']['reveal'] = !this._ui['form']['updatePassword']['field']['newPassword']['reveal'];

                                this.setState(() {});

                              },
                            ),
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          obscureText: !this._ui['form']['updatePassword']['field']['newPassword']['reveal'],
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => this._ui['form']['updatePassword']['field']['repeatNewPassword']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['updatePassword']['field']['repeatNewPassword']['focusNode'],
                          controller: this._ui['form']['updatePassword']['field']['repeatNewPassword']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['updatePassword']['field']['repeatNewPassword']['label'],
                            hintText: this._ui['form']['updatePassword']['field']['repeatNewPassword']['hint'],
                            errorText: this._ui['form']['updatePassword']['field']['repeatNewPassword']['error'],
                            suffixIcon: IconButton(
                              icon: FaIcon(
                                this._ui['form']['updatePassword']['field']['repeatNewPassword']['reveal'] ? pickIcon('eye') : pickIcon('eye-slash'),
                              ),
                              onPressed: () {

                                this._ui['form']['updatePassword']['field']['repeatNewPassword']['reveal'] = !this._ui['form']['updatePassword']['field']['repeatNewPassword']['reveal'];

                                this.setState(() {});

                              },
                            ),
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          obscureText: !this._ui['form']['updatePassword']['field']['repeatNewPassword']['reveal'],
                          textInputAction: TextInputAction.done,
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
                      this._ui['form']['updatePassword']['button']['update']['label'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: !this._ui['form']['updatePassword']['button']['update']['enabled'] ? null : () => this._cancelableTask.run('_updatePassword', this._updatePassword(context)),
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

    final req.Request request = req.Request('get', '/garage/password/update');

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
            'updatePassword': {
              'field': {
                'currentPassword': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.updatePassword.field.currentPassword.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.updatePassword.field.currentPassword.hint') ?? '',
                  'error': null,
                  'reveal': DeepMap(response.body).getBool('form.updatePassword.field.currentPassword.reveal') ?? false,
                },
                'newPassword': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.updatePassword.field.newPassword.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.updatePassword.field.newPassword.hint') ?? '',
                  'error': null,
                  'reveal': DeepMap(response.body).getBool('form.updatePassword.field.newPassword.reveal') ?? false,
                },
                'repeatNewPassword': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.updatePassword.field.repeatNewPassword.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.updatePassword.field.repeatNewPassword.hint') ?? '',
                  'error': null,
                  'reveal': DeepMap(response.body).getBool('form.updatePassword.field.repeatNewPassword.reveal') ?? false,
                },
              },
              'button': {
                'update': {
                  'label': DeepMap(response.body).getString('form.updatePassword.button.update.label') ?? '',
                  'enabled': true,
                },
              },
            },
          },
        };

        this._ui['form']['updatePassword']['field']['currentPassword']['controller'].text = DeepMap(response.body).getString('form.updatePassword.field.currentPassword.value') ?? '';
        this._ui['form']['updatePassword']['field']['newPassword']['controller'].text = DeepMap(response.body).getString('form.updatePassword.field.newPassword.value') ?? '';
        this._ui['form']['updatePassword']['field']['repeatNewPassword']['controller'].text = DeepMap(response.body).getString('form.updatePassword.field.repeatNewPassword.value') ?? '';

        break;

      }

    }

    this.setState(() {});

  }

  void _disposeUi() {

    this._cancelableTask.cancel();

    DeepMap(this._ui).getValue('form.updatePassword.field.currentPassword.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.updatePassword.field.newPassword.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.updatePassword.field.repeatNewPassword.focusNode')?.dispose();

    DeepMap(this._ui).getValue('form.updatePassword.field.currentPassword.controller')?.dispose();
    DeepMap(this._ui).getValue('form.updatePassword.field.newPassword.controller')?.dispose();
    DeepMap(this._ui).getValue('form.updatePassword.field.repeatNewPassword.controller')?.dispose();

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

  Future<void> _updatePassword(BuildContext context) async {

    this._ui['form']['updatePassword']['button']['update']['enabled'] = false;
    this._ui['form']['updatePassword']['field']['currentPassword']['error'] = null;
    this._ui['form']['updatePassword']['field']['newPassword']['error'] = null;
    this._ui['form']['updatePassword']['field']['repeatNewPassword']['error'] = null;

    this.setState(() {});

    final req.Request request = req.Request('put', '/garage/password/update');

    request.bodyFields = {
      'currentPassword': this._ui['form']['updatePassword']['field']['currentPassword']['controller'].text,
      'newPassword': this._ui['form']['updatePassword']['field']['newPassword']['controller'].text,
      'repeatNewPassword': this._ui['form']['updatePassword']['field']['repeatNewPassword']['controller'].text,
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

            this._ui['form']['updatePassword']['field']['currentPassword']['error'] = DeepMap(field).getString('currentPassword.message');
            this._ui['form']['updatePassword']['field']['newPassword']['error'] = DeepMap(field).getString('newPassword.message');
            this._ui['form']['updatePassword']['field']['repeatNewPassword']['error'] = DeepMap(field).getString('repeatNewPassword.message');

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

            Navigator.pop(context);

            break;

          }

        }

        break;

      }

    }

    this._ui['form']['updatePassword']['button']['update']['enabled'] = true;

    this.setState(() {});

  }

}
