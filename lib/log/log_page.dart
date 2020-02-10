import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/aggregate_category_page.dart';
import 'package:poodo/log/edit_condition_dialog.dart';
import 'package:poodo/log/expense.dart';
import 'package:poodo/log/log.dart';
import 'package:poodo/log/condition_log.dart';

class LogPage extends StatefulWidget {
  final DateTime _date;

  LogPage(this._date);

  @override
  _LogPageState createState() => _LogPageState(_date);
}

class _LogPageState extends State<LogPage> {
  DateTime _date;
  DateFormat _format = DateFormat('yyyy/MM/dd(E)');
  List<Expense> _listFood = [];
  List<Expense> _listDailyuse = [];
  List<Expense> _listHealthcare = [];
  List<Expense> _listLuxury = [];
  List<ConditionLog> _morningCondition;
  List<ConditionLog> _noonCondition;
  List<ConditionLog> _nightCondition;
  int _conditionRank = 70;
  Aggregate aggregate;

  _LogPageState(this._date);

  Future<void> _init() async {
    await DbProvider().database;
    initializeDateFormatting('ja');

    _listFood = await Log.getLogAtDay('food', _date);
    _listDailyuse = await Log.getLogAtDay('dailyuse', _date);
    _listHealthcare = await Log.getLogAtDay('healthcare', _date);
    _listLuxury = await Log.getLogAtDay('luxury', _date);

    aggregate = await Log.getAggregate(_date);

    _morningCondition =
        await Log.getConditionLog(_date, ConditionCategory.MORNING);
    _noonCondition = await Log.getConditionLog(_date, ConditionCategory.NOON);
    _nightCondition = await Log.getConditionLog(_date, ConditionCategory.NIGHT);

    setState(() {});
  }

  @override
  void initState() {
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
          title: Text(_format.format(_date)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () async {
                setState(() {
                  _date = _date.subtract(Duration(days: 1));
                });
                await _init();
              },
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () async {
                setState(() {
                  _date = _date.add(Duration(days: 1));
                });
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
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () async {
                          await _init();
                          //AggregateDialog.displayDialog(context, aggregate);
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                              return AggreagateCategoryPage(aggregate);
                            }),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        aggregate.dayTotal.toString(),
                        style: TextStyle(
                            fontSize: 32.0, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
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
                    _setFlatButton(context, 'food', _date),
                    _setFlatButton(context, 'dailyuse', _date),
                    _setFlatButton(context, 'healthcare', _date),
                    _setFlatButton(context, 'luxury', _date),
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
                      child: _expenseItemList('food', _listFood),
                    ),
                    Expanded(
                      child: _expenseItemList('dailyuse', _listDailyuse),
                    ),
                    Expanded(
                      child: _expenseItemList('healthcare', _listHealthcare),
                    ),
                    Expanded(
                      child: _expenseItemList('luxury', _listLuxury),
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
                                _conditionRank = 100 -
                                    _morningCondition[0].condition * 10 -
                                    _noonCondition[0].condition * 10 -
                                    _nightCondition[0].condition * 10;
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
                                _conditionRank = 100 -
                                    _morningCondition[0].condition * 10 -
                                    _noonCondition[0].condition * 10 -
                                    _nightCondition[0].condition * 10;
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
                                _conditionRank = 100 -
                                    _morningCondition[0].condition * 10 -
                                    _noonCondition[0].condition * 10 -
                                    _nightCondition[0].condition * 10;
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

  Widget _setFlatButton(BuildContext context, String category, DateTime date) {
    return Expanded(
      child: RaisedButton(
        color: Colors.yellow[200],
        child: Text(category),
        onPressed: () async {
          await Log.addLog(context, category, date);
          await _init();
        },
        shape: UnderlineInputBorder(),
      ),
    );
  }

  Widget _expenseItemList(String category, List<Expense> list) {
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
                      list[index].cost.toString(),
                      // highlight expired item
                      style: TextStyle(color: Colors.black, height: 0.0),
                    ),
                  ],
                ),
                onTap: () async {
                  await Log.updateLog(context, category, list[index].id);
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
}
