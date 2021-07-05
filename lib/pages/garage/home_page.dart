import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../api/api.dart' as api;
import '../../api/req/req.dart' as req;
import '../../api/res/res.dart' as res;

import '../../helpers/date_time_value.dart';
import '../../helpers/date_time_range_value.dart';
import '../../helpers/floating_action_button_animation.dart';

import '../../utils/cancelable_task.dart';
import '../../utils/deep_map.dart';
import '../../utils/pick_icon.dart';

import '../../widgets/error_box.dart';

import '../../dialogs/garage/booking/delete_booking_dialog.dart';

import './booking/filter_booking_page.dart';
import './booking/view_booking_page.dart';
import './booking/add_booking_page.dart';
import './booking/update_booking_page.dart';
import './account/update_account_page.dart';
import './account/update_password_page.dart';
import './auth/login_page.dart';

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
          body: Column(
            children: [
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    focusNode: this._ui['form']['searchBooking']['field']['term']['focusNode'],
                    controller: this._ui['form']['searchBooking']['field']['term']['controller'],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: 12.0,
                        top: 12.0,
                        right: 36.0,
                        bottom: 12.0,
                      ),
                      hintText: this._ui['form']['searchBooking']['field']['term']['hint'],
                      prefixIcon: Icon(
                        pickIcon('search'),
                      ),
                      filled: true,
                    ),
                    textAlignVertical: TextAlignVertical.bottom,
                    textInputAction: TextInputAction.search,
                    onEditingComplete: () {

                      this._ui['form']['searchBooking']['field']['term']['focusNode'].unfocus();
                      this._ui['list']['booking']['pagingController'].refresh();

                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      pickIcon('sliders-h'),
                    ),
                    color: Colors.black45,
                    onPressed: () => this._cancelableTask.run('_openFilterBookingPage', this._openFilterBookingPage(context)),
                  ),
                ],
              ),
              SizedBox(
                height: 1.0,
              ),
              Expanded(
                child: RefreshIndicator(
                  child: PagedListView(
                    scrollController: this._ui['list']['booking']['scrollController'],
                    pagingController: this._ui['list']['booking']['pagingController'],
                    builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                      firstPageErrorIndicatorBuilder: (BuildContext context) {
                        return ErrorBox(
                          message: this._ui['list']['booking']['pagingController'].error,
                          onRetry: () => this._ui['list']['booking']['pagingController'].retryLastFailedRequest(),
                        );
                      },
                      newPageErrorIndicatorBuilder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 16.0,
                            bottom: 100.0,
                          ),
                          child: Material(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        this._ui['list']['booking']['pagingController'].error,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      FaIcon(
                                        pickIcon('sync'),
                                        size: 16.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () => this._ui['list']['booking']['pagingController'].retryLastFailedRequest(),
                            ),
                          ),
                        );
                      },
                      noItemsFoundIndicatorBuilder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                pickIcon('search'),
                                color: Theme.of(context).primaryColor,
                                size: 128.0,
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                              Text(
                                this._ui['list']['booking']['message']['empty'],
                                style: TextStyle(
                                  fontSize: Theme.of(context).primaryTextTheme.subtitle1!.fontSize,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                      noMoreItemsIndicatorBuilder: (BuildContext context) {
                        return SizedBox(
                          height: 100.0,
                        );
                      },
                      itemBuilder: (BuildContext context, Map<String, dynamic> item, int index) {
                        return MetaData(
                          metaData: {
                            'bookingId': item['info']['bookingId'],
                          },
                          child: Builder(
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  top: 16.0,
                                  right: 16.0,
                                  bottom: 0.0,
                                ),
                                child: Material(
                                  type: MaterialType.card,
                                  elevation: 1.0,
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Container(
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['info']['vehiclePlate']['label'],
                                                  style: TextStyle(
                                                    color: Theme.of(context).textTheme.headline1!.color,
                                                  ),
                                                ),
                                                Text(
                                                  item['info']['vehiclePlate']['value'],
                                                ),
                                                Divider(
                                                  height: 16.0,
                                                  color: Colors.transparent,
                                                ),
                                                Text(
                                                  item['info']['vehicleEntry']['label'],
                                                  style: TextStyle(
                                                    color: Theme.of(context).textTheme.headline1!.color,
                                                  ),
                                                ),
                                                Text(
                                                  item['info']['vehicleEntry']['dateTimeValue'].mask,
                                                ),
                                                Divider(
                                                  height: 16.0,
                                                  color: Colors.transparent,
                                                ),
                                                Text(
                                                  item['info']['vehicleExit']['label'],
                                                  style: TextStyle(
                                                    color: Theme.of(context).textTheme.headline1!.color,
                                                  ),
                                                ),
                                                Text(
                                                  item['info']['vehicleExit']['dateTimeValue'].mask,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                          PopupMenuButton<String>(
                                            icon: FaIcon(
                                              pickIcon('ellipsis-v'),
                                              color: Theme.of(context).textTheme.headline1!.color,
                                            ),
                                            itemBuilder: (BuildContext context) => item['menu']['item'].map<PopupMenuEntry<String>>((Map<String, dynamic> item) {
                                              return PopupMenuItem<String>(
                                                child: Text(
                                                  item['title'],
                                                ),
                                                value: item['value'],
                                              );
                                            }).toList(),
                                            onSelected: (String value) => this._cancelableTask.run('_bookingItemPopupMenuSelectionHandler', this._bookingItemPopupMenuSelectionHandler(context, value)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => this._cancelableTask.run('_openViewBookingPage', this._openViewBookingPage(context)),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    physics: AlwaysScrollableScrollPhysics(),
                  ),
                  onRefresh: () => Future.sync(() => this._ui['list']['booking']['pagingController'].refresh()),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: FaIcon(
              pickIcon('plus'),
            ),
            onPressed: () => this._cancelableTask.run('_openAddBookingPage', this._openAddBookingPage(context)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButtonAnimator: FloatingActionButtonAnimation(),
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
              'form': {
                'searchBooking': {
                  'field': {
                    'term': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'hint': DeepMap(response.body).getString('form.searchBooking.field.term.hint') ?? '',
                    },
                  },
                },
              },
              'list': {
                'booking': {
                  'scrollController': ScrollController(),
                  'pagingController': PagingController<int, Map<String, dynamic>>(
                    firstPageKey: 1,
                  ),
                  'message': {
                    'empty': DeepMap(response.body).getString('list.booking.message.empty') ?? '',
                  },
                  'pageSize': 20,
                },
              },
              'page': {
                'filterBooking': {
                  'title': DeepMap(response.body).getString('page.filterBooking.title') ?? '',
                  'actionMenu': {
                    'item': {
                      'clearFilter': {
                        'title': DeepMap(response.body).getString('page.filterBooking.actionMenu.item.clearFilter.title') ?? '',
                      },
                    },
                  },
                  'form': {
                    'filterBooking': {
                      'field': {
                        'vehicleEntry': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleEntry.label') ?? '',
                          'hint': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleEntry.hint') ?? '',
                          'dateTimeRangeValue': DateTimeRangeValue(
                            valueSeparator: ' - ',
                            valueFormat: 'yyyy/M/d',
                            maskSeparator: ' - ',
                            maskFormat: 'd MMM yyyy',
                            maskLocale: Localizations.localeOf(this.context).languageCode,
                          ),
                          'default': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleEntry.default') ?? '',
                          'pickerHint': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleEntry.pickerHint') ?? '',
                        },
                        'vehicleExit': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleExit.label') ?? '',
                          'hint': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleExit.hint') ?? '',
                          'dateTimeRangeValue': DateTimeRangeValue(
                            valueSeparator: ' - ',
                            valueFormat: 'yyyy/M/d',
                            maskSeparator: ' - ',
                            maskFormat: 'd MMM yyyy',
                            maskLocale: Localizations.localeOf(this.context).languageCode,
                          ),
                          'default': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleExit.default') ?? '',
                          'pickerHint': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleExit.pickerHint') ?? '',
                        },
                        'orderBy': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.orderBy.label') ?? '',
                          'hint': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.orderBy.hint') ?? '',
                          'item': DeepMap(response.body).getList<Map<String, dynamic>>('page.filterBooking.form.filterBooking.field.orderBy.item').map<Map<String, dynamic>>((Map<String, dynamic> item) {

                            return {
                              'label': DeepMap(item).getString('label') ?? '',
                              'value': DeepMap(item).getString('value') ?? '',
                            };

                          }).toList(),
                          'default': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.orderBy.default') ?? '',
                        },
                        'order': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.order.label') ?? '',
                          'hint': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.order.hint') ?? '',
                          'item': DeepMap(response.body).getList<Map<String, dynamic>>('page.filterBooking.form.filterBooking.field.order.item').map<Map<String, dynamic>>((Map<String, dynamic> item) {

                            return {
                              'label': DeepMap(item).getString('label') ?? '',
                              'value': DeepMap(item).getString('value') ?? '',
                            };

                          }).toList(),
                          'default': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.order.default') ?? '',
                        },
                      },
                      'button': {
                        'apply': {
                          'label': DeepMap(response.body).getString('page.filterBooking.form.filterBooking.button.apply.label') ?? '',
                        },
                      },
                    },
                  },
                },
              },
            };

            this._ui['form']['searchBooking']['field']['term']['controller'].text = DeepMap(response.body).getString('form.searchBooking.field.term.value') ?? '';
            this._ui['page']['filterBooking']['form']['filterBooking']['field']['vehicleEntry']['dateTimeRangeValue'].value = DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleEntry.value') ?? '';
            this._ui['page']['filterBooking']['form']['filterBooking']['field']['vehicleEntry']['controller'].text = this._ui['page']['filterBooking']['form']['filterBooking']['field']['vehicleEntry']['dateTimeRangeValue'].mask;
            this._ui['page']['filterBooking']['form']['filterBooking']['field']['vehicleExit']['dateTimeRangeValue'].value = DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.vehicleExit.value') ?? '';
            this._ui['page']['filterBooking']['form']['filterBooking']['field']['vehicleExit']['controller'].text = this._ui['page']['filterBooking']['form']['filterBooking']['field']['vehicleExit']['dateTimeRangeValue'].mask;
            this._ui['page']['filterBooking']['form']['filterBooking']['field']['orderBy']['controller'].text = DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.orderBy.value') ?? '';
            this._ui['page']['filterBooking']['form']['filterBooking']['field']['order']['controller'].text = DeepMap(response.body).getString('page.filterBooking.form.filterBooking.field.order.value') ?? '';

            this._ui['list']['booking']['pagingController'].addStatusListener((PagingStatus status) => this._bookingListPagingStatusHandler(status));

            this._ui['list']['booking']['pagingController'].addPageRequestListener((int pageKey) => this._cancelableTask.run('_bookingListPageRequestHandler', this._bookingListPageRequestHandler(pageKey)));

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

    DeepMap(this._ui).getValue('form.searchBooking.field.term.focusNode')?.dispose();
    DeepMap(this._ui).getValue('page.filterBooking.form.filterBooking.field.vehicleEntry.focusNode')?.dispose();
    DeepMap(this._ui).getValue('page.filterBooking.form.filterBooking.field.vehicleExit.focusNode')?.dispose();
    DeepMap(this._ui).getValue('page.filterBooking.form.filterBooking.field.orderBy.focusNode')?.dispose();
    DeepMap(this._ui).getValue('page.filterBooking.form.filterBooking.field.order.focusNode')?.dispose();

    DeepMap(this._ui).getValue('form.searchBooking.field.term.controller')?.dispose();
    DeepMap(this._ui).getValue('page.filterBooking.form.filterBooking.field.vehicleEntry.controller')?.dispose();
    DeepMap(this._ui).getValue('page.filterBooking.form.filterBooking.field.vehicleExit.controller')?.dispose();
    DeepMap(this._ui).getValue('page.filterBooking.form.filterBooking.field.orderBy.controller')?.dispose();
    DeepMap(this._ui).getValue('page.filterBooking.form.filterBooking.field.order.controller')?.dispose();

    DeepMap(this._ui).getValue('list.booking.scrollController')?.dispose();

    DeepMap(this._ui).getValue('list.booking.pagingController')?.dispose();

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

  Future<void> _openFilterBookingPage(BuildContext context) async {

    final bool? filtered = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FilterBookingPage(
            ui: this._ui['page']['filterBooking'],
          );
        },
      ),
    );

    if (filtered != null) {

      this._ui['list']['booking']['pagingController'].refresh();

    }

  }

  Future<void> _openViewBookingPage(BuildContext context) async {

    final MetaData? metaData = context.findAncestorWidgetOfExactType<MetaData>();

    if (metaData != null) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ViewBookingPage(
              bookingId: metaData.metaData['bookingId'],
            );
          },
        ),
      );

    }

  }

  Future<void> _openAddBookingPage(BuildContext context) async {

    final bool? added = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddBookingPage();
        },
      ),
    );

    if (added != null) {

      this._ui['list']['booking']['pagingController'].refresh();

    }

  }

  Future<void> _openUpdateBookingPage(BuildContext context) async {

    final MetaData? metaData = context.findAncestorWidgetOfExactType<MetaData>();

    if (metaData != null) {

      final bool? updated = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return UpdateBookingPage(
              bookingId: metaData.metaData['bookingId'],
            );
          },
        ),
      );

      if (updated != null) {

        this._ui['list']['booking']['pagingController'].refresh();

      }

    }

  }

  Future<void> _openDeleteBookingDialog(BuildContext context) async {

    final MetaData? metaData = context.findAncestorWidgetOfExactType<MetaData>();

    if (metaData != null) {

      final bool? deleted = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DeleteBookingDialog(
            bookingId: metaData.metaData['bookingId'],
          );
        },
      );

      if (deleted != null) {

        this._ui['list']['booking']['pagingController'].refresh();

      }

    }

  }

  Future<void> _bookingItemPopupMenuSelectionHandler(BuildContext context, String value) async {

    switch (value) {

      case 'updateBooking': {

        await this._openUpdateBookingPage(context);

        break;

      }
      case 'deleteBooking': {

        await this._openDeleteBookingDialog(context);

        break;

      }

    }

  }

  void _bookingListPagingStatusHandler(PagingStatus status) {

    if (status == PagingStatus.subsequentPageError) {

      this._ui['list']['booking']['scrollController'].animateTo(
        this._ui['list']['booking']['scrollController'].position.maxScrollExtent + 16.0 + 100.0,
        curve: Curves.fastOutSlowIn,
        duration: Duration(
          milliseconds: 275,
        ),
      );

    }

  }

  Future<void> _bookingListPageRequestHandler(int pageKey) async {

    final req.Request request = req.Request('get', '/garage/booking/list', {
      'term': this._ui['form']['searchBooking']['field']['term']['controller'].text,
      'vehicleEntry': this._ui['page']['filterBooking']['form']['filterBooking']['field']['vehicleEntry']['dateTimeRangeValue'].value,
      'vehicleExit': this._ui['page']['filterBooking']['form']['filterBooking']['field']['vehicleExit']['dateTimeRangeValue'].value,
      'orderBy': this._ui['page']['filterBooking']['form']['filterBooking']['field']['orderBy']['controller'].text,
      'order': this._ui['page']['filterBooking']['form']['filterBooking']['field']['order']['controller'].text,
      'page': pageKey.toString(),
      'pageSize': this._ui['list']['booking']['pageSize'].toString(),
    });

    final res.Response response = await api.send(request);

    switch (response.status) {

      case res.Status.FailedConnection:
      case res.Status.ServerError:
      case res.Status.BadResponse:
      case res.Status.BadRequest:
      case res.Status.Forbidden: {

        final String message = DeepMap(response.body).getString('message') ?? '';

        this._ui['list']['booking']['pagingController'].error = message;

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
        final String message = DeepMap(response.body).getString('message') ?? '';

        switch (state) {

          case 1: {

            this._ui['list']['booking']['pagingController'].error = message;

            break;

          }
          case 2: {

            final List<Map<String, dynamic>> items = DeepMap(response.body).getList<Map<String, dynamic>>('items').map<Map<String, dynamic>>((Map<String, dynamic> item) {

              final Map<String, dynamic> _item = {
                'info': {
                  'bookingId': DeepMap(item).getInt('info.bookingId') ?? 0,
                  'vehiclePlate': {
                    'label': DeepMap(item).getString('info.vehiclePlate.label') ?? '',
                    'value': DeepMap(item).getString('info.vehiclePlate.value') ?? '',
                  },
                  'vehicleEntry': {
                    'label': DeepMap(item).getString('info.vehicleEntry.label') ?? '',
                    'dateTimeValue': DateTimeValue(
                      valueFormat: 'yyyy/M/d H:m',
                      maskFormat: 'E d \'de\' MMM \'del\' yyyy\',\' HH:mm \'hrs.\'',
                      maskLocale: Localizations.localeOf(this.context).languageCode,
                    ),
                  },
                  'vehicleExit': {
                    'label': DeepMap(item).getString('info.vehicleExit.label') ?? '',
                    'dateTimeValue': DateTimeValue(
                      valueFormat: 'yyyy/M/d H:m',
                      maskFormat: 'E d \'de\' MMM \'del\' yyyy\',\' HH:mm \'hrs.\'',
                      maskLocale: Localizations.localeOf(this.context).languageCode,
                    ),
                  },
                },
                'menu': {
                  'item': DeepMap(item).getList<Map<String, dynamic>>('menu.item').map<Map<String, dynamic>>((Map<String, dynamic> item) {

                    return {
                      'title': DeepMap(item).getString('title') ?? '',
                      'value': DeepMap(item).getString('value') ?? '',
                    };

                  }).toList(),
                },
              };

              _item['info']['vehicleEntry']['dateTimeValue'].value = DeepMap(item).getString('info.vehicleEntry.value') ?? '';
              _item['info']['vehicleExit']['dateTimeValue'].value = DeepMap(item).getString('info.vehicleExit.value') ?? '';

              return _item;

            }).toList();

            if (items.length < this._ui['list']['booking']['pageSize']) {

              this._ui['list']['booking']['pagingController'].appendLastPage(items);

            } else {

              this._ui['list']['booking']['pagingController'].appendPage(items, ++pageKey);

            }

            break;

          }

        }

        break;

      }

    }

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
