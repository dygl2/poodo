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
import 'package:poodo/account_credential.dart';

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
  List<ConditionLog> _morningCondition = [
    new ConditionLog(
        date: DateTime.now().toString(),
        category: ConditionCategory.MORNING.index,
        condition: Condition.MODERATELY_GOOD.index)
  ]..length = 1;
  List<ConditionLog> _noonCondition = [
    new ConditionLog(
        date: DateTime.now().toString(),
        category: ConditionCategory.NOON.index,
        condition: Condition.MODERATELY_GOOD.index)
  ]..length = 1;
  List<ConditionLog> _nightCondition = [
    new ConditionLog(
        date: DateTime.now().toString(),
        category: ConditionCategory.NIGHT.index,
        condition: Condition.MODERATELY_GOOD.index)
  ]..length = 1;
  int _conditionRank = 70;
  Aggregate _aggregate = new Aggregate(DateTime.now());

  _LogPageState();

  final accountCredentials = new ServiceAccountCredentials.fromJson(credential);

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
