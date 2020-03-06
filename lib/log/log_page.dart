import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/category_breakdown_page.dart';
import 'package:poodo/log/edit_condition_dialog.dart';
import 'package:poodo/log/expense.dart';
import 'package:poodo/log/log.dart';
import 'package:poodo/log/log_category.dart';
import 'package:poodo/log/condition_log.dart';
import 'package:poodo/todo/todo.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleCalendar;
import 'package:googleapis_auth/auth_io.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

List<Todo> listEvents = [];

class _LogPageState extends State<LogPage> {
  DateTime _date;
  static DateFormat _dateFormat = DateFormat('yyyy/MM/dd(E)');
  NumberFormat _currencyFormat = NumberFormat("#,##0");
  List<Expense> _listFood = [];
  List<Expense> _listDailyuse = [];
  List<Expense> _listHealthcare = [];
  List<Expense> _listLuxury = [];
  List<ConditionLog> _morningCondition;
  List<ConditionLog> _noonCondition;
  List<ConditionLog> _nightCondition;
  int _conditionRank = 70;
  Aggregate _aggregate;

  _LogPageState();

  final accountCredentials = new ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "dygl2-poodo",
    "private_key_id": "0fd36f10737e42c4fcefdb93c75ae84de24e3b31",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCpo8MvDOfC04vT\n55+rVc/17dNPAK4vMKI6Oa4g142RKIKp6JMv01rZC/SZdsd/PZx3vzJJWB914iZv\nMddLCxtB1hxlaYfkxTloLncGtK9EzW2w/pI7T4J46CYi72dW0TMuPq8yu5ix9Lbp\ngwba9qfhF1Ds1lFZdSbLbKezGGkG7tJJc9Idk8Q6pjRAR+O3a4o6a/Maa8/sZ3gF\nPAZUl1IVEoSNMAicXJaXwBih+ZOkb4wsIsTOJx21gkvvtBkhyv7kW0FMDFtFsp22\nnBGm32yR5SHog0vj80SmXdGwLWDSjgv3cBMz4czfmw6ZBPMvagkNQb7Katg47ccl\nPO9QWtubAgMBAAECggEAU3X+HCJxziFNXKrLHD1CbSEewvI3QIFhd1sUiBT1EhNH\nwfdqnu+R9VJT+8L8IOZ7mlCnmX0xMUrcFP4FCedDeE8ytlRG5y9/cHnX1qVDzApz\n6s48vNCABSNWS/7ULVsMnrZ5dPDmDbuz2Ew+LbGH5A8YIgXJjUU9mnzxPwSF+8Hq\nFfJ8BOFGozYRtU2HidHNNv71EypxZa1OiYBTZnISHVoYWewDiyUah/u3UONX5HWo\nonNnM//A8L/uSToK+RrupBCbrmtPu0rxITWpvkE5Xi97leFWtCOsOKuf38pHCq66\nGeW2Q87ave0ltyv45pb577nl9OBwP5Ev8fLulBO94QKBgQDvFfhKNWLFIDYY2qsT\ndGsRy+7vX+/YAog7cQC3TOH6EohkFc4HbCH+fEOtTYPo7Zv/oS0QLOUmZZ8o7V03\nHHQzElaVTa+GYcdq/Wz6sbEJrEVHliJzDpjpAzR4g4eUIEH+CppaaAoiW5ol7jLB\nyx+uSGWRxEVOcqisqfC4ztVRoQKBgQC1pBG7cqjM/Bhb/5VBnManc5B4TvFDbAo2\nP60ahP7I0vfGXB+TDJlM09dZVH59TiaFWD7R63kpm/szi8lwBu+HK7i/Y8lyqTM+\nF3bVBzA9PoRnTVdbyP30RvDEO4FgyjaEGdR4V7F8+dX3a6LofXCnqIViAreybt0S\nKvVBIARbuwKBgQDhVvqqrsCF/QMfz9GYR4y2vFhaIzkChfhy1eIP4ZXHRfppIqgK\nFN/BZMvApqOiQXlbqUS4zye3VeZ6A6Zs0BOxIyKaHBtIdBYpf+xcKGgtLsIpY5ba\njLKQQ+YLhCSf9vtb/hBXD2Il2eJix6vtPY6BjFi2159e/fB+tLle5grmoQKBgFDX\nZMz4iwgwaucHKXa6P+/nDzV8bQSE4UajsHdNGdhnjL9L4QGhadk3r3CimmlKjvpp\n/AuRsatDMNoQLOcfLxwJ6X/E+bN+er/30XueZ2namTMgyPCg0+YUbLPph/t8BCdn\nF5k37lahGwmzbh3rNmhoKHUmoHtZvCqJ0/3YMhhhAoGBAIP94eG/gzM28uNm/m+z\nlF6c+D+OdHMb83IZqLakcsM3WPxFqdkUiHHJn8T16iM4fVqQ3pKyjY9fGUvllhZV\n6rnET6kOpiGSIOPoM2+d61AUlmylHjFn2QyfoZOoZhbe4CbGM3wBdFARjoadEIQ6\nYduGhFMhlTEw53ujAlmoNHj6\n-----END PRIVATE KEY-----\n",
    "client_email": "dygl2-001@dygl2-poodo.iam.gserviceaccount.com",
    "client_id": "107587000322886211467",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/dygl2-001%40dygl2-poodo.iam.gserviceaccount.com"
  });

  var _scopes = [
    GoogleCalendar.CalendarApi.CalendarScope
  ]; //defines the scopes for the calendar api

  Future<List<Todo>> _getCalendarEvents() async {
    List<Todo> list = [];

    clientViaServiceAccount(accountCredentials, _scopes).then((client) {
      var calendar = new GoogleCalendar.CalendarApi(client);
      var calEvents = calendar.events.list("t0m013h@gmail.com");
      calEvents.then((GoogleCalendar.Events events) {
        events.items.forEach((GoogleCalendar.Event event) {
          DateTime date;
          if (event.start.dateTime != null) {
            date = event.start.dateTime;
          } else {
            date = event.end.date;
          }
          if (date.isAfter(
              DateTime.now().add(DateTime.now().timeZoneOffset).toUtc())) {
            int dateUnixTime = date.millisecondsSinceEpoch;
            String tmpContent = event.summary;

            list.add(new Todo(
                id: DateTime.now().millisecondsSinceEpoch,
                content: tmpContent,
                date: dateUnixTime));
            print(list[list.length - 1].content);
          }
        });
      });
    });

    if (list != null) {
      list.sort((a, b) => a.date.compareTo(b.date));
    }

    return list;
  }

  Future<void> _init() async {
    await DbProvider().database;

    _listFood = await Log.getLogAtDay(LogCategory.food, _date);
    _listDailyuse = await Log.getLogAtDay(LogCategory.dailyuse, _date);
    _listHealthcare = await Log.getLogAtDay(LogCategory.healthcare, _date);
    _listLuxury = await Log.getLogAtDay(LogCategory.luxury, _date);

    _aggregate = await Log.getAggregate(_date);

    _morningCondition =
        await Log.getConditionLog(_date, ConditionCategory.MORNING);
    _noonCondition = await Log.getConditionLog(_date, ConditionCategory.NOON);
    _nightCondition = await Log.getConditionLog(_date, ConditionCategory.NIGHT);

    _updateConditionRank();

    // TODO: this should be in todo_page.dart
    listEvents = await _getCalendarEvents();

    setState(() {});
  }

  @override
  void initState() {
    initializeDateFormatting('ja');

    _date = DateTime.now();

    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_dateFormat.format(_date)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () async {
                _date = _date.subtract(Duration(days: 1));
                await _init();
              },
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () async {
                _date = _date.add(Duration(days: 1));
                await _init();
              },
            ),
            IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () async {
                await _setDate(context);
                await _init();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Total\t',
                        style: TextStyle(
                            fontSize: 32.0, fontStyle: FontStyle.italic),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        _currencyFormat.format(_aggregate.dayTotal).toString(),
                        style: TextStyle(
                            fontSize: 32.0, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                              return CategoryBreakdownPage(_aggregate);
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  children: <Widget>[
                    _setFlatButton(context, LogCategory.food, _date),
                    _setFlatButton(context, LogCategory.dailyuse, _date),
                    _setFlatButton(context, LogCategory.healthcare, _date),
                    _setFlatButton(context, LogCategory.luxury, _date),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                //padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _expenseItemList(LogCategory.food, _listFood),
                    ),
                    Expanded(
                      child:
                          _expenseItemList(LogCategory.dailyuse, _listDailyuse),
                    ),
                    Expanded(
                      child: _expenseItemList(
                          LogCategory.healthcare, _listHealthcare),
                    ),
                    Expanded(
                      child: _expenseItemList(LogCategory.luxury, _listLuxury),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text('morning'),
                        IconButton(
                            icon: _setConditionLog(
                                _morningCondition[0].condition),
                            onPressed: () async {
                              var result =
                                  await EditConditionDialog.displayDialog(
                                      context);
                              if (result != null) {
                                _morningCondition[0].condition = result;
                              }

                              await DbProvider().update(
                                  'condition',
                                  _morningCondition[0],
                                  _morningCondition[0].id);

                              setState(() {
                                _updateConditionRank();
                              });
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text('noon'),
                        IconButton(
                            icon: _setConditionLog(_noonCondition[0].condition),
                            onPressed: () async {
                              var result =
                                  await EditConditionDialog.displayDialog(
                                      context);
                              if (result != null) {
                                _noonCondition[0].condition = result;
                              }

                              await DbProvider().update('condition',
                                  _noonCondition[0], _noonCondition[0].id);

                              setState(() {
                                _updateConditionRank();
                              });
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text('night'),
                        IconButton(
                            icon:
                                _setConditionLog(_nightCondition[0].condition),
                            onPressed: () async {
                              var result =
                                  await EditConditionDialog.displayDialog(
                                      context);
                              if (result != null) {
                                _nightCondition[0].condition = result;
                              }

                              await DbProvider().update('condition',
                                  _nightCondition[0], _nightCondition[0].id);

                              setState(() {
                                _updateConditionRank();
                              });
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text('Rank: ' + _conditionRank.toString()),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> _setDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _date = date;
      });
    }
  }

  Widget _setFlatButton(
      BuildContext context, LogCategory category, DateTime date) {
    return Expanded(
      child: RaisedButton(
        color: Colors.yellow[200],
        child: Text(category.toString().split('.')[1]),
        onPressed: () async {
          await Log.addLog(context, category, date);
          await _init();
        },
        shape: UnderlineInputBorder(),
      ),
    );
  }

  Widget _expenseItemList(LogCategory category, List<Expense> list) {
    return Container(
      child: ListView.builder(
        itemCount: list.length,
        itemExtent: 50.0,
        scrollDirection: Axis.vertical,
        //shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      _currencyFormat.format(list[index].cost).toString(),
                      // highlight expired item
                      style: TextStyle(color: Colors.black, height: 0.0),
                    ),
                  ],
                ),
                onTap: () async {
                  await Log.updateLog(context, category, list[index].cost,
                      list[index].remarks, list[index].id);
                  await _init();
                },
                onLongPress: () async {
                  await Log.deleteLog(context, category, list, index);
                  await _init();
                }),
          );
        },
      ),
    );
  }

  dynamic _setConditionLog(int cnd) {
    Image ret;

    switch (Condition.values[cnd]) {
      case Condition.VERY_BAD:
        ret = new Image.asset('assets/icons/very_bad.png');
        break;
      case Condition.NOT_VERY_GOOD:
        ret = new Image.asset('assets/icons/not_very_good.png');
        break;
      case Condition.MODERATELY_GOOD:
        ret = new Image.asset('assets/icons/moderately_good.png');
        break;
      case Condition.VERY_GOOD:
        ret = new Image.asset('assets/icons/very_good.png');
        break;
    }

    return ret;
  }

  void _updateConditionRank() {
    _conditionRank = 100 -
        _morningCondition[0].condition * 10 -
        _noonCondition[0].condition * 10 -
        _nightCondition[0].condition * 10;
  }
}
