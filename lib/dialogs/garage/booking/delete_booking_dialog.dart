import 'package:flutter/material.dart';

import '../../../../api/api.dart' as api;
import '../../../../api/req/req.dart' as req;
import '../../../../api/res/res.dart' as res;

import '../../../../utils/cancelable_task.dart';
import '../../../../utils/deep_map.dart';

import '../../../../widgets/error_box.dart';

import '../../../../pages/auth/login_page.dart';

class DeleteBookingDialog extends StatefulWidget {

  final int bookingId;

  DeleteBookingDialog({Key? key, required this.bookingId}) : super(key: key);

  @override
  _DeleteBookingDialogState createState() => _DeleteBookingDialogState();

}

class _DeleteBookingDialogState extends State<DeleteBookingDialog> {

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

    Widget dialog = GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: UnconstrainedBox(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          onTap: () {},
        ),
      ),
      onTap: () => Navigator.pop(context),
    );

    if (this._ui.isNotEmpty) {

      if (this._ui.containsKey('error')) {

        dialog = GestureDetector(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              child: AlertDialog(
                scrollable: true,
                contentPadding: EdgeInsets.zero,
                content: ErrorBox(
                  message: this._ui['error']['message'],
                  onRetry: () => this._retry(),
                ),
              ),
              onTap: () {},
            ),
          ),
          onTap: () => Navigator.pop(context),
        );

      } else {

        dialog = GestureDetector(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              child: AlertDialog(
                scrollable: true,
                title: Text(
                  this._ui['title'],
                  overflow: TextOverflow.ellipsis,
                ),
                content: ListBody(
                  children: [
                    Text(
                      this._ui['content'],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text(
                      this._ui['form']['deleteBooking']['button']['cancel']['label'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text(
                      this._ui['form']['deleteBooking']['button']['delete']['label'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: !this._ui['form']['deleteBooking']['button']['delete']['enabled'] ? null : () => this._cancelableTask.run('_deleteBooking', this._deleteBooking(context)),
                  ),
                ],
              ),
              onTap: () {},
            ),
          ),
          onTap: () => Navigator.pop(context),
        );

      }

    }

    return dialog;

  }

  Future<void> _initUi() async {

    final req.Request request = req.Request('get', '/garage/booking/delete/${this.widget.bookingId}');

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
              'content': DeepMap(response.body).getString('content') ?? '',
              'form': {
                'deleteBooking': {
                  'button': {
                    'cancel': {
                      'label': DeepMap(response.body).getString('form.deleteBooking.button.cancel.label') ?? '',
                    },
                    'delete': {
                      'label': DeepMap(response.body).getString('form.deleteBooking.button.delete.label') ?? '',
                      'enabled': true,
                    },
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

  Future<void> _deleteBooking(BuildContext context) async {

    this._ui['form']['deleteBooking']['button']['delete']['enabled'] = false;

    this.setState(() {});

    final req.Request request = req.Request('delete', '/garage/booking/delete/${this.widget.bookingId}');

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

        switch (state) {

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

    this._ui['form']['deleteBooking']['button']['delete']['enabled'] = true;

    this.setState(() {});

  }

}
