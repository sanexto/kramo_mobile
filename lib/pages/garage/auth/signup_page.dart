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

class SignupPage extends StatefulWidget {

  SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {

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
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (this._ui.isNotEmpty) {

      if (this._ui.containsKey('error')) {

        page = Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor,
            ),
          ),
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
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor,
            ),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 64.0,
                      horizontal: 32.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            this._ui['title'],
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline1!.color,
                              fontSize: Theme.of(context).primaryTextTheme.headline5!.fontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        TextField(
                          autofocus: true,
                          focusNode: this._ui['form']['signup']['field']['garage']['focusNode'],
                          controller: this._ui['form']['signup']['field']['garage']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['signup']['field']['garage']['label'],
                            hintText: this._ui['form']['signup']['field']['garage']['hint'],
                            errorText: this._ui['form']['signup']['field']['garage']['error'],
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => this._ui['form']['signup']['field']['email']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['signup']['field']['email']['focusNode'],
                          controller: this._ui['form']['signup']['field']['email']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['signup']['field']['email']['label'],
                            hintText: this._ui['form']['signup']['field']['email']['hint'],
                            errorText: this._ui['form']['signup']['field']['email']['error'],
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => this._ui['form']['signup']['field']['username']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['signup']['field']['username']['focusNode'],
                          controller: this._ui['form']['signup']['field']['username']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['signup']['field']['username']['label'],
                            hintText: this._ui['form']['signup']['field']['username']['hint'],
                            errorText: this._ui['form']['signup']['field']['username']['error'],
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => this._ui['form']['signup']['field']['password']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['signup']['field']['password']['focusNode'],
                          controller: this._ui['form']['signup']['field']['password']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['signup']['field']['password']['label'],
                            hintText: this._ui['form']['signup']['field']['password']['hint'],
                            errorText: this._ui['form']['signup']['field']['password']['error'],
                            suffixIcon: IconButton(
                              icon: FaIcon(
                                this._ui['form']['signup']['field']['password']['reveal'] ? pickIcon('eye') : pickIcon('eye-slash'),
                              ),
                              onPressed: () {

                                this._ui['form']['signup']['field']['password']['reveal'] = !this._ui['form']['signup']['field']['password']['reveal'];

                                this.setState(() {});

                              },
                            ),
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          obscureText: !this._ui['form']['signup']['field']['password']['reveal'],
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => this._ui['form']['signup']['field']['repeatPassword']['focusNode'].requestFocus(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: this._ui['form']['signup']['field']['repeatPassword']['focusNode'],
                          controller: this._ui['form']['signup']['field']['repeatPassword']['controller'],
                          decoration: InputDecoration(
                            labelText: this._ui['form']['signup']['field']['repeatPassword']['label'],
                            hintText: this._ui['form']['signup']['field']['repeatPassword']['hint'],
                            errorText: this._ui['form']['signup']['field']['repeatPassword']['error'],
                            suffixIcon: IconButton(
                              icon: FaIcon(
                                this._ui['form']['signup']['field']['repeatPassword']['reveal'] ? pickIcon('eye') : pickIcon('eye-slash'),
                              ),
                              onPressed: () {

                                this._ui['form']['signup']['field']['repeatPassword']['reveal'] = !this._ui['form']['signup']['field']['repeatPassword']['reveal'];

                                this.setState(() {});

                              },
                            ),
                            errorMaxLines: 100,
                            filled: true,
                          ),
                          obscureText: !this._ui['form']['signup']['field']['repeatPassword']['reveal'],
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
                              this._ui['form']['signup']['button']['signup']['label'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: !this._ui['form']['signup']['button']['signup']['enabled'] ? null : () => this._cancelableTask.run('_signup', this._signup(context)),
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

    final req.Request request = req.Request('get', '/garage/auth/signup');

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
            'signup': {
              'field': {
                'garage': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.signup.field.garage.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.signup.field.garage.hint') ?? '',
                  'error': null,
                },
                'email': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.signup.field.email.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.signup.field.email.hint') ?? '',
                  'error': null,
                },
                'username': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.signup.field.username.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.signup.field.username.hint') ?? '',
                  'error': null,
                },
                'password': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.signup.field.password.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.signup.field.password.hint') ?? '',
                  'error': null,
                  'reveal': DeepMap(response.body).getBool('form.signup.field.password.reveal') ?? false,
                },
                'repeatPassword': {
                  'focusNode': FocusNode(),
                  'controller': TextEditingController(),
                  'label': DeepMap(response.body).getString('form.signup.field.repeatPassword.label') ?? '',
                  'hint': DeepMap(response.body).getString('form.signup.field.repeatPassword.hint') ?? '',
                  'error': null,
                  'reveal': DeepMap(response.body).getBool('form.signup.field.repeatPassword.reveal') ?? false,
                },
              },
              'button': {
                'signup': {
                  'label': DeepMap(response.body).getString('form.signup.button.signup.label') ?? '',
                  'enabled': true,
                },
              },
            },
          },
        };

        this._ui['form']['signup']['field']['garage']['controller'].text = DeepMap(response.body).getString('form.signup.field.garage.value') ?? '';
        this._ui['form']['signup']['field']['email']['controller'].text = DeepMap(response.body).getString('form.signup.field.email.value') ?? '';
        this._ui['form']['signup']['field']['username']['controller'].text = DeepMap(response.body).getString('form.signup.field.username.value') ?? '';
        this._ui['form']['signup']['field']['password']['controller'].text = DeepMap(response.body).getString('form.signup.field.password.value') ?? '';
        this._ui['form']['signup']['field']['repeatPassword']['controller'].text = DeepMap(response.body).getString('form.signup.field.repeatPassword.value') ?? '';

        break;

      }

    }

    this.setState(() {});

  }

  void _disposeUi() {

    this._cancelableTask.cancel();

    DeepMap(this._ui).getValue('form.signup.field.garage.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.signup.field.email.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.signup.field.username.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.signup.field.password.focusNode')?.dispose();
    DeepMap(this._ui).getValue('form.signup.field.repeatPassword.focusNode')?.dispose();

    DeepMap(this._ui).getValue('form.signup.field.garage.controller')?.dispose();
    DeepMap(this._ui).getValue('form.signup.field.email.controller')?.dispose();
    DeepMap(this._ui).getValue('form.signup.field.username.controller')?.dispose();
    DeepMap(this._ui).getValue('form.signup.field.password.controller')?.dispose();
    DeepMap(this._ui).getValue('form.signup.field.repeatPassword.controller')?.dispose();

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

  Future<void> _signup(BuildContext context) async {

    this._ui['form']['signup']['button']['signup']['enabled'] = false;
    this._ui['form']['signup']['field']['garage']['error'] = null;
    this._ui['form']['signup']['field']['email']['error'] = null;
    this._ui['form']['signup']['field']['username']['error'] = null;
    this._ui['form']['signup']['field']['password']['error'] = null;
    this._ui['form']['signup']['field']['repeatPassword']['error'] = null;

    this.setState(() {});

    final req.Request request = req.Request('post', '/garage/auth/signup');

    request.bodyFields = {
      'garage': this._ui['form']['signup']['field']['garage']['controller'].text,
      'email': this._ui['form']['signup']['field']['email']['controller'].text,
      'username': this._ui['form']['signup']['field']['username']['controller'].text,
      'password': this._ui['form']['signup']['field']['password']['controller'].text,
      'repeatPassword': this._ui['form']['signup']['field']['repeatPassword']['controller'].text,
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

            this._ui['form']['signup']['field']['garage']['error'] = DeepMap(field).getString('garage.message');
            this._ui['form']['signup']['field']['email']['error'] = DeepMap(field).getString('email.message');
            this._ui['form']['signup']['field']['username']['error'] = DeepMap(field).getString('username.message');
            this._ui['form']['signup']['field']['password']['error'] = DeepMap(field).getString('password.message');
            this._ui['form']['signup']['field']['repeatPassword']['error'] = DeepMap(field).getString('repeatPassword.message');

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

    this._ui['form']['signup']['button']['signup']['enabled'] = true;

    this.setState(() {});

  }

}
