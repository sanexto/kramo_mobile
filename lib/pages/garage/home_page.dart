import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ars_dialog/ars_dialog.dart';

import '../../api/api.dart' as api;
import '../../api/req/req.dart' as req;
import '../../api/res/res.dart' as res;

import '../../utils/cancelable_task.dart';
import '../../utils/deep_map.dart';
import '../../utils/pick_icon.dart';

import '../../widgets/error_box.dart';

import '../auth/login_page.dart';
import './account/update_account_page.dart';
import './account/update_password_page.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    this._ui['garageAccount']['fullName'],
                  ),
                  accountEmail: Text(
                    this._ui['garageAccount']['username'],
                  ),
                  currentAccountPicture: CircleAvatar(
                    child: Text(
                      this._ui['garageAccount']['picture'],
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    this._ui['navMenu']['item']['updateAccount']['title'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Container(
                    width: 34.0,
                    alignment: Alignment.center,
                    child: FaIcon(
                      pickIcon('user-circle'),
                    ),
                  ),
                  onTap: () => this._cancelableTask.run('_openUpdateAccountPage', this._openUpdateAccountPage(context)),
                ),
                ListTile(
                  title: Text(
                    this._ui['navMenu']['item']['updatePassword']['title'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Container(
                    width: 34.0,
                    alignment: Alignment.center,
                    child: FaIcon(
                      pickIcon('user-lock'),
                    ),
                  ),
                  onTap: () => this._cancelableTask.run('_openUpdatePasswordPage', this._openUpdatePasswordPage(context)),
                ),
                ListTile(
                  title: Text(
                    this._ui['navMenu']['item']['logout']['title'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Container(
                    width: 34.0,
                    alignment: Alignment.center,
                    child: FaIcon(
                      pickIcon('power-off'),
                    ),
                  ),
                  onTap: () => this._cancelableTask.run('_logout', this._logout(context)),
                ),
              ],
            ),
          ),
          body: Text(
            'aca van las reservas',
          ),
        );

      }

    }

    return page;

  }

  Future<void> _initUi() async {

    final req.Request request = req.Request('get', '/garage');

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
              'garageAccount': {
                'fullName': DeepMap(response.body).getString('garageAccount.fullName') ?? '',
                'username': DeepMap(response.body).getString('garageAccount.username') ?? '',
                'picture': DeepMap(response.body).getString('garageAccount.picture') ?? '',
              },
              'navMenu': {
                'item': {
                  'updateAccount': {
                    'title': DeepMap(response.body).getString('navMenu.item.updateAccount.title') ?? '',
                  },
                  'updatePassword': {
                    'title': DeepMap(response.body).getString('navMenu.item.updatePassword.title') ?? '',
                  },
                  'logout': {
                    'title': DeepMap(response.body).getString('navMenu.item.logout.title') ?? '',
                  },
                },
              },
            };

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

  Future<void> _openUpdateAccountPage(BuildContext context) async {

    Navigator.pop(context);

    final Map<String, dynamic>? garageAccount = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return UpdateAccountPage();
        },
      ),
    );

    if (garageAccount != null && garageAccount.isNotEmpty) {

      this._ui['garageAccount']['fullName'] = DeepMap(garageAccount).getString('fullName') ?? '';
      this._ui['garageAccount']['username'] = DeepMap(garageAccount).getString('username') ?? '';
      this._ui['garageAccount']['picture'] = DeepMap(garageAccount).getString('picture') ?? '';

      this.setState(() {});

    }

  }

  Future<void> _openUpdatePasswordPage(BuildContext context) async {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return UpdatePasswordPage();
        },
      ),
    );

  }

  Future<void> _logout(BuildContext context) async {

    Navigator.pop(context);

    final CustomProgressDialog progressDialog = CustomProgressDialog(
      context,
      blur: 2,
      dismissable: false,
      loadingWidget: SizedBox.shrink(),
      transitionDuration: Duration.zero,
    );

    progressDialog.show();

    final FlutterSecureStorage storage = FlutterSecureStorage();

    bool deleted = false;

    try {

      await storage.delete(key: 'token');
      await storage.delete(key: 'profile');

      deleted = true;

    } catch (_) {}

    if (deleted) {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginPage();
          },
        ),
        (Route<dynamic> route) => false,
      );

    } else {

      progressDialog.dismiss();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocurrió un error en la aplicación',
          ),
        ),
      );

    }

  }

}
