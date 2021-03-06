import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:poodo/db_provider.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/category_breakdown_page.dart';
import 'package:poodo/log/edit_condition_dialog.dart';
import 'package:poodo/log/expense.dart';
import 'package:poodo/log/log_service.dart';
import 'package:poodo/log/log_category.dart';
import 'package:poodo/log/condition_log.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

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

  Future<void> _init() async {
    await DbProvider().database;

    _listFood = await LogService.getLogAtDay(LogCategory.food, _date);
    _listDailyuse = await LogService.getLogAtDay(LogCategory.dailyuse, _date);
    _listHealthcare =
        await LogService.getLogAtDay(LogCategory.healthcare, _date);
    _listLuxury = await LogService.getLogAtDay(LogCategory.luxury, _date);

    _aggregate = await LogService.getAggregate(_date);

    _morningCondition =
        await LogService.getConditionLog(_date, ConditionCategory.MORNING);
    _noonCondition =
        await LogService.getConditionLog(_date, ConditionCategory.NOON);
    _nightCondition =
        await LogService.getConditionLog(_date, ConditionCategory.NIGHT);

    _conditionRank = ConditionLog.updateConditionRank(
        _morningCondition[0].condition,
        _noonCondition[0].condition,
        _nightCondition[0].condition);

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
                            icon: ConditionLog.setConditionLog(
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
                                _conditionRank =
                                    ConditionLog.updateConditionRank(
                                        _morningCondition[0].condition,
                                        _noonCondition[0].condition,
                                        _nightCondition[0].condition);
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
                            icon: ConditionLog.setConditionLog(
                                _noonCondition[0].condition),
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
                                _conditionRank =
                                    ConditionLog.updateConditionRank(
                                        _morningCondition[0].condition,
                                        _noonCondition[0].condition,
                                        _nightCondition[0].condition);
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
                            icon: ConditionLog.setConditionLog(
                                _nightCondition[0].condition),
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
                                _conditionRank =
                                    ConditionLog.updateConditionRank(
                                        _morningCondition[0].condition,
                                        _noonCondition[0].condition,
                                        _nightCondition[0].condition);
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
          await LogService.addLog(context, category, date);
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
                  await LogService.updateLog(context, category,
                      list[index].cost, list[index].remarks, list[index].id);
                  await _init();
                },
                onLongPress: () async {
                  await LogService.deleteLog(context, category, list, index);
                  await _init();
                }),
          );
        },
      ),
    );
  }
}
