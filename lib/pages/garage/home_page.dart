import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
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

import '../../dialogs/garage/parking/delete_parking_dialog.dart';

import './parking/filter_parking_page.dart';
import './parking/view_parking_page.dart';
import './parking/add_parking_page.dart';
import './parking/update_parking_page.dart';
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
                  leading: Container(
                    width: 34.0,
                    alignment: Alignment.center,
                    child: FaIcon(
                      pickIcon('user-circle'),
                    ),
                  ),
                  title: Text(
                    this._ui['navMenu']['item']['updateAccount']['title'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => this._cancelableTask.run('_openUpdateAccountPage', this._openUpdateAccountPage(context)),
                ),
                ListTile(
                  leading: Container(
                    width: 34.0,
                    alignment: Alignment.center,
                    child: FaIcon(
                      pickIcon('user-lock'),
                    ),
                  ),
                  title: Text(
                    this._ui['navMenu']['item']['updatePassword']['title'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => this._cancelableTask.run('_openUpdatePasswordPage', this._openUpdatePasswordPage(context)),
                ),
                ListTile(
                  leading: Container(
                    width: 34.0,
                    alignment: Alignment.center,
                    child: FaIcon(
                      pickIcon('power-off'),
                    ),
                  ),
                  title: Text(
                    this._ui['navMenu']['item']['logout']['title'],
                    overflow: TextOverflow.ellipsis,
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
                    focusNode: this._ui['form']['searchParking']['field']['term']['focusNode'],
                    controller: this._ui['form']['searchParking']['field']['term']['controller'],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: 12.0,
                        top: 12.0,
                        right: 36.0,
                        bottom: 12.0,
                      ),
                      hintText: this._ui['form']['searchParking']['field']['term']['hint'],
                      prefixIcon: Icon(
                        pickIcon('search'),
                      ),
                      filled: true,
                    ),
                    textAlignVertical: TextAlignVertical.bottom,
                    textInputAction: TextInputAction.search,
                    onEditingComplete: () {

                      this._ui['form']['searchParking']['field']['term']['focusNode'].unfocus();
                      this._ui['list']['parking']['pagingController'].refresh();

                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      pickIcon('sliders-h'),
                    ),
                    color: Colors.black45,
                    onPressed: () => this._cancelableTask.run('_openFilterParkingPage', this._openFilterParkingPage(context)),
                  ),
                ],
              ),
              SizedBox(
                height: 1.0,
              ),
              Expanded(
                child: RefreshIndicator(
                  child: PagedListView(
                    scrollController: this._ui['list']['parking']['scrollController'],
                    pagingController: this._ui['list']['parking']['pagingController'],
                    builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                      firstPageErrorIndicatorBuilder: (BuildContext context) {
                        return ErrorBox(
                          message: this._ui['list']['parking']['pagingController'].error,
                          onRetry: () => this._ui['list']['parking']['pagingController'].retryLastFailedRequest(),
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
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        this._ui['list']['parking']['pagingController'].error,
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
                              onTap: () => this._ui['list']['parking']['pagingController'].retryLastFailedRequest(),
                            ),
                          ),
                        );
                      },
                      noItemsFoundIndicatorBuilder: (BuildContext context) {
                        return Padding(
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
                                this._ui['list']['parking']['message']['empty'],
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
                            'parkingId': item['info']['parkingId'],
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
                                    child: Padding(
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
                                            onSelected: (String value) => this._cancelableTask.run('_parkingItemPopupMenuSelectionHandler', this._parkingItemPopupMenuSelectionHandler(context, value)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => this._cancelableTask.run('_openViewParkingPage', this._openViewParkingPage(context)),
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
                  onRefresh: () => Future.sync(() => this._ui['list']['parking']['pagingController'].refresh()),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: FaIcon(
              pickIcon('plus'),
            ),
            onPressed: () => this._cancelableTask.run('_openAddParkingPage', this._openAddParkingPage(context)),
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
                'searchParking': {
                  'field': {
                    'term': {
                      'focusNode': FocusNode(),
                      'controller': TextEditingController(),
                      'hint': DeepMap(response.body).getString('form.searchParking.field.term.hint') ?? '',
                    },
                  },
                },
              },
              'list': {
                'parking': {
                  'scrollController': ScrollController(),
                  'pagingController': PagingController<int, Map<String, dynamic>>(
                    firstPageKey: 1,
                  ),
                  'message': {
                    'empty': DeepMap(response.body).getString('list.parking.message.empty') ?? '',
                  },
                  'pageSize': 20,
                },
              },
              'page': {
                'filterParking': {
                  'title': DeepMap(response.body).getString('page.filterParking.title') ?? '',
                  'actionMenu': {
                    'item': {
                      'clearFilter': {
                        'title': DeepMap(response.body).getString('page.filterParking.actionMenu.item.clearFilter.title') ?? '',
                      },
                    },
                  },
                  'form': {
                    'filterParking': {
                      'field': {
                        'vehicleEntry': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleEntry.label') ?? '',
                          'hint': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleEntry.hint') ?? '',
                          'dateTimeRangeValue': DateTimeRangeValue(
                            valueSeparator: ' - ',
                            valueFormat: 'yyyy/M/d',
                            maskSeparator: ' - ',
                            maskFormat: 'd MMM yyyy',
                            maskLocale: Localizations.localeOf(this.context).languageCode,
                          ),
                          'default': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleEntry.default') ?? '',
                          'pickerHint': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleEntry.pickerHint') ?? '',
                        },
                        'vehicleExit': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleExit.label') ?? '',
                          'hint': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleExit.hint') ?? '',
                          'dateTimeRangeValue': DateTimeRangeValue(
                            valueSeparator: ' - ',
                            valueFormat: 'yyyy/M/d',
                            maskSeparator: ' - ',
                            maskFormat: 'd MMM yyyy',
                            maskLocale: Localizations.localeOf(this.context).languageCode,
                          ),
                          'default': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleExit.default') ?? '',
                          'pickerHint': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleExit.pickerHint') ?? '',
                        },
                        'orderBy': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.orderBy.label') ?? '',
                          'hint': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.orderBy.hint') ?? '',
                          'item': DeepMap(response.body).getList<Map<String, dynamic>>('page.filterParking.form.filterParking.field.orderBy.item').map<Map<String, dynamic>>((Map<String, dynamic> item) {

                            return {
                              'label': DeepMap(item).getString('label') ?? '',
                              'value': DeepMap(item).getString('value') ?? '',
                            };

                          }).toList(),
                          'default': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.orderBy.default') ?? '',
                        },
                        'order': {
                          'focusNode': FocusNode(),
                          'controller': TextEditingController(),
                          'label': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.order.label') ?? '',
                          'hint': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.order.hint') ?? '',
                          'item': DeepMap(response.body).getList<Map<String, dynamic>>('page.filterParking.form.filterParking.field.order.item').map<Map<String, dynamic>>((Map<String, dynamic> item) {

                            return {
                              'label': DeepMap(item).getString('label') ?? '',
                              'value': DeepMap(item).getString('value') ?? '',
                            };

                          }).toList(),
                          'default': DeepMap(response.body).getString('page.filterParking.form.filterParking.field.order.default') ?? '',
                        },
                      },
                      'button': {
                        'apply': {
                          'label': DeepMap(response.body).getString('page.filterParking.form.filterParking.button.apply.label') ?? '',
                        },
                      },
                    },
                  },
                },
              },
            };

            this._ui['form']['searchParking']['field']['term']['controller'].text = DeepMap(response.body).getString('form.searchParking.field.term.value') ?? '';
            this._ui['page']['filterParking']['form']['filterParking']['field']['vehicleEntry']['dateTimeRangeValue'].value = DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleEntry.value') ?? '';
            this._ui['page']['filterParking']['form']['filterParking']['field']['vehicleEntry']['controller'].text = this._ui['page']['filterParking']['form']['filterParking']['field']['vehicleEntry']['dateTimeRangeValue'].mask;
            this._ui['page']['filterParking']['form']['filterParking']['field']['vehicleExit']['dateTimeRangeValue'].value = DeepMap(response.body).getString('page.filterParking.form.filterParking.field.vehicleExit.value') ?? '';
            this._ui['page']['filterParking']['form']['filterParking']['field']['vehicleExit']['controller'].text = this._ui['page']['filterParking']['form']['filterParking']['field']['vehicleExit']['dateTimeRangeValue'].mask;
            this._ui['page']['filterParking']['form']['filterParking']['field']['orderBy']['controller'].text = DeepMap(response.body).getString('page.filterParking.form.filterParking.field.orderBy.value') ?? '';
            this._ui['page']['filterParking']['form']['filterParking']['field']['order']['controller'].text = DeepMap(response.body).getString('page.filterParking.form.filterParking.field.order.value') ?? '';

            this._ui['list']['parking']['pagingController'].addStatusListener((PagingStatus status) => this._parkingListPagingStatusHandler(status));

            this._ui['list']['parking']['pagingController'].addPageRequestListener((int pageKey) => this._cancelableTask.run('_parkingListPageRequestHandler', this._parkingListPageRequestHandler(pageKey)));

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

    DeepMap(this._ui).getValue('form.searchParking.field.term.focusNode')?.dispose();
    DeepMap(this._ui).getValue('page.filterParking.form.filterParking.field.vehicleEntry.focusNode')?.dispose();
    DeepMap(this._ui).getValue('page.filterParking.form.filterParking.field.vehicleExit.focusNode')?.dispose();
    DeepMap(this._ui).getValue('page.filterParking.form.filterParking.field.orderBy.focusNode')?.dispose();
    DeepMap(this._ui).getValue('page.filterParking.form.filterParking.field.order.focusNode')?.dispose();

    DeepMap(this._ui).getValue('form.searchParking.field.term.controller')?.dispose();
    DeepMap(this._ui).getValue('page.filterParking.form.filterParking.field.vehicleEntry.controller')?.dispose();
    DeepMap(this._ui).getValue('page.filterParking.form.filterParking.field.vehicleExit.controller')?.dispose();
    DeepMap(this._ui).getValue('page.filterParking.form.filterParking.field.orderBy.controller')?.dispose();
    DeepMap(this._ui).getValue('page.filterParking.form.filterParking.field.order.controller')?.dispose();

    DeepMap(this._ui).getValue('list.parking.scrollController')?.dispose();

    DeepMap(this._ui).getValue('list.parking.pagingController')?.dispose();

    this._ui = {};

  }

  void _retry() {

    this._disposeUi();

    this.setState(() {});

    this._cancelableTask.run('_initUi', this._initUi());

  }

  Future<void> _openFilterParkingPage(BuildContext context) async {

    final bool? filtered = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FilterParkingPage(
            ui: this._ui['page']['filterParking'],
          );
        },
      ),
    );

    if (filtered != null) {

      this._ui['list']['parking']['pagingController'].refresh();

    }

  }

  Future<void> _openViewParkingPage(BuildContext context) async {

    final MetaData? metaData = context.findAncestorWidgetOfExactType<MetaData>();

    if (metaData != null) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ViewParkingPage(
              parkingId: metaData.metaData['parkingId'],
            );
          },
        ),
      );

    }

  }

  Future<void> _openAddParkingPage(BuildContext context) async {

    final bool? added = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddParkingPage();
        },
      ),
    );

    if (added != null) {

      this._ui['list']['parking']['pagingController'].refresh();

    }

  }

  Future<void> _openUpdateParkingPage(BuildContext context) async {

    final MetaData? metaData = context.findAncestorWidgetOfExactType<MetaData>();

    if (metaData != null) {

      final bool? updated = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return UpdateParkingPage(
              parkingId: metaData.metaData['parkingId'],
            );
          },
        ),
      );

      if (updated != null) {

        this._ui['list']['parking']['pagingController'].refresh();

      }

    }

  }

  Future<void> _openDeleteParkingDialog(BuildContext context) async {

    final MetaData? metaData = context.findAncestorWidgetOfExactType<MetaData>();

    if (metaData != null) {

      final bool? deleted = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DeleteParkingDialog(
            parkingId: metaData.metaData['parkingId'],
          );
        },
      );

      if (deleted != null) {

        this._ui['list']['parking']['pagingController'].refresh();

      }

    }

  }

  Future<void> _parkingItemPopupMenuSelectionHandler(BuildContext context, String value) async {

    switch (value) {

      case 'updateParking': {

        await this._openUpdateParkingPage(context);

        break;

      }
      case 'deleteParking': {

        await this._openDeleteParkingDialog(context);

        break;

      }

    }

  }

  void _parkingListPagingStatusHandler(PagingStatus status) {

    if (status == PagingStatus.subsequentPageError) {

      this._ui['list']['parking']['scrollController'].animateTo(
        this._ui['list']['parking']['scrollController'].position.maxScrollExtent + 16.0 + 100.0,
        curve: Curves.fastOutSlowIn,
        duration: Duration(
          milliseconds: 275,
        ),
      );

    }

  }

  Future<void> _parkingListPageRequestHandler(int pageKey) async {

    final req.Request request = req.Request('get', '/garage/parking/list', {
      'term': this._ui['form']['searchParking']['field']['term']['controller'].text,
      'vehicleEntry': this._ui['page']['filterParking']['form']['filterParking']['field']['vehicleEntry']['dateTimeRangeValue'].value,
      'vehicleExit': this._ui['page']['filterParking']['form']['filterParking']['field']['vehicleExit']['dateTimeRangeValue'].value,
      'orderBy': this._ui['page']['filterParking']['form']['filterParking']['field']['orderBy']['controller'].text,
      'order': this._ui['page']['filterParking']['form']['filterParking']['field']['order']['controller'].text,
      'page': pageKey.toString(),
      'pageSize': this._ui['list']['parking']['pageSize'].toString(),
    });

    final res.Response response = await api.send(request);

    switch (response.status) {

      case res.Status.FailedConnection:
      case res.Status.ServerError:
      case res.Status.BadResponse:
      case res.Status.BadRequest:
      case res.Status.Forbidden: {

        final String message = DeepMap(response.body).getString('message') ?? '';

        this._ui['list']['parking']['pagingController'].error = message;

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

            this._ui['list']['parking']['pagingController'].error = message;

            break;

          }
          case 2: {

            final List<Map<String, dynamic>> items = DeepMap(response.body).getList<Map<String, dynamic>>('items').map<Map<String, dynamic>>((Map<String, dynamic> item) {

              final Map<String, dynamic> _item = {
                'info': {
                  'parkingId': DeepMap(item).getInt('info.parkingId') ?? 0,
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

            if (items.length < this._ui['list']['parking']['pageSize']) {

              this._ui['list']['parking']['pagingController'].appendLastPage(items);

            } else {

              this._ui['list']['parking']['pagingController'].appendPage(items, ++pageKey);

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
      blur: 1,
      dismissable: false,
      loadingWidget: SizedBox.shrink(),
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
