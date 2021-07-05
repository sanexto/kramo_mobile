import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../api/api.dart' as api;
import '../../../api/req/req.dart' as req;
import '../../../api/res/res.dart' as res;

import '../../../utils/cancelable_task.dart';
import '../../../utils/deep_map.dart';
import '../../../utils/pick_icon.dart';

import '../../../widgets/error_box.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (this._ui.isNotEmpty) {

      if (this._ui.containsKey('error')) {

        page = Scaffold(
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
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          this._ui['title'],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontSize: Theme.of(context).primaryTextTheme.headline2!.fontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: Theme.of(context).primaryTextTheme.headline2!.fontSize,
                        ),
                        TextField(
                          autofocus: true,
                          focusNode: this._ui['form']['login']['field']['username']['focusNode'],
                          controller: this._ui['form']['login']['field']['username']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['login']['field']['username']['label'],
                            hintText: this._ui['form']['login']['field']['username']['hint'],
                            errorText: this._ui['form']['login']['field']['username']['error'],
                            prefixIcon: Icon(
                              pickIcon('user'),
                            ),
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => this._ui['form']['login']['field']['password']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['login']['field']['password']['focusNode'],
                          controller: this._ui['form']['login']['field']['password']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['login']['field']['password']['label'],
                            hintText: this._ui['form']['login']['field']['password']['hint'],
                            errorText: this._ui['form']['login']['field']['password']['error'],
                            prefixIcon: Icon(
                              pickIcon('lock'),
                            ),
                            suffixIcon: IconButton(
                              icon: FaIcon(
                                this._ui['form']['login']['field']['password']['reveal'] ? pickIcon('eye') : pickIcon('eye-slash'),
                              ),
                              onPressed: () {

                                this._ui['form']['login']['field']['password']['reveal'] = !this._ui['form']['login']['field']['password']['reveal'];

                                this.setState(() {});

                              },
                            ),
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          obscureText: !this._ui['form']['login']['field']['password']['reveal'],
                          textInputAction: TextInputAction.done,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: Theme.of(context).primaryTextTheme.headline2!.fontSize,
                          child: ElevatedButton(
                            child: Text(
                              this._ui['form']['login']['button']['login']['label'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: !this._ui['form']['login']['button']['login']['enabled'] ? null : () => this._cancelableTask.run('_login', this._login(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );

      }

    }

    return page;

  }

  Future<void> _initUi() async {

    final req.Request request = req.Request('get', '/garage/auth/login');

    final res.Response response = await api.send(request);

    switch (response.status) {

      case res.Status.FailedConnection:
      case res.Status.ServerError:
      case res.Status.BadResponse:
      case res.Status.BadRequest: {

        this._ui = {
          'error': {
            'message': DeepMap(response.body).getString('message') ?? '',
          },
        };

        break;

      }
      case res.Status.Ok: {

        this._ui = {
          'title': DeepMap(response.body).getString('title') ?? '',
          'form': {
            'login': {
              'field': {
                'username': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.login.field.username.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.login.field.username.hint') ?? '',
                  'error': null,
                },
                'password': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.login.field.password.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.login.field.password.hint') ?? '',
                  'error': null,
                  'reveal': DeepMap(response.body).getBool('form.login.field.password.reveal') ?? false,
                },
              },
              'button': {
                'login': {
                  'label': DeepMap(response.body).getString('form.login.button.login.label') ?? '',
                  'enabled': true,
                },
              },
            },
          },
        };

        this._ui['form']['login']['field']['username']['controller'].text = DeepMap(response.body).getString('form.login.field.username.value') ?? '';
        this._ui['form']['login']['field']['password']['controller'].text = DeepMap(response.body).getString('form.login.field.password.value') ?? '';

        break;

      }

    }

    this.setState(() {});

  }

  void _disposeUi() {

    this._cancelableTask.cancel();

    DeepMap(this._ui).getValue('form.login.field.username.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.login.field.password.focusNode')?.dispose();

    DeepMap(this._ui).getValue('form.login.field.username.controller')?.dispose();
    DeepMap(this._ui).getValue('form.login.field.password.controller')?.dispose();

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

  Future<void> _login(BuildContext context) async {

    this._ui['form']['login']['button']['login']['enabled'] = false;
    this._ui['form']['login']['field']['username']['error'] = null;
    this._ui['form']['login']['field']['password']['error'] = null;

    this.setState(() {});

    final req.Request request = req.Request('post', '/garage/auth/login');

    request.bodyFields = {
      'username': this._ui['form']['login']['field']['username']['controller'].text,
      'password': this._ui['form']['login']['field']['password']['controller'].text,
    };

    final res.Response response = await api.send(request);

    switch (response.status) {

      case res.Status.FailedConnection:
      case res.Status.ServerError:
      case res.Status.BadResponse:
      case res.Status.BadRequest: {

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
      case res.Status.Ok: {

        final int state = DeepMap(response.body).getInt('state') ?? 0;
        final String message = DeepMap(response.body).getString('message') ?? '';
        final Map<String, dynamic> field = DeepMap(response.body).getMap('field');

        switch (state) {

          case 1: {

            this._ui['form']['login']['field']['username']['error'] = DeepMap(field).getString('username.message');
            this._ui['form']['login']['field']['password']['error'] = DeepMap(field).getString('password.message');

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

            final String token = DeepMap(response.body).getString('session.token') ?? '';

            final FlutterSecureStorage storage = FlutterSecureStorage();

            bool written = false;

            try {

              await storage.write(key: 'token', value: token);

              written = true;

            } catch (_) {}

            if (written) {

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomePage();
                  },
                ),
                (Route<dynamic> route) => false,
              );

            } else {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ocurrió un error en la aplicación',
                  ),
                ),
              );

            }

            break;

          }

        }

        break;

      }

    }

    this._ui['form']['login']['button']['login']['enabled'] = true;

    this.setState(() {});

  }

}
