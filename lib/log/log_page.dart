import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/log/aggregate.dart';
import 'package:poodo/log/aggregate_dialog.dart';
import 'package:poodo/log/expense.dart';
import 'package:poodo/log/log.dart';

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
  Aggregate aggregate;

  _LogPageState(this._date);

  void _init() async {
    await DbProvider().database;

    _listFood = await Log.getLogAtDay('food', _date);
    _listDailyuse = await Log.getLogAtDay('dailyuse', _date);
    _listHealthcare = await Log.getLogAtDay('healthcare', _date);
    _listLuxury = await Log.getLogAtDay('luxury', _date);

    aggregate = await Log.getAggregate();

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
              onPressed: () {
                _date = _date.subtract(new Duration(days: 1));
                setState(() {
                  _init();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                _date = _date.add(new Duration(days: 1));
                setState(() {
                  _init();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () async {
                await _setDate(context);
                _init();
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
                        aggregate.dayTotal.toString(),
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
                            _init();
                            AggregateDialog.displayDialog(context, aggregate);
                          },
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        child: Text('food'),
                        onPressed: () async {
                          await Log.addLog(context, 'food', _date);
                          _init();
                        },
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text('daily use'),
                        onPressed: () async {
                          await Log.addLog(context, 'dailyuse', _date);
                          _init();
                        },
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text('health care'),
                        onPressed: () async {
                          await Log.addLog(context, 'healthcare', _date);
                          _init();
                        },
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text('luxury'),
                        onPressed: () async {
                          await Log.addLog(context, 'luxury', _date);
                          _init();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
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
                  await Log.updateLog(context, category, list[index].id, _date);
                  _init();
                },
                onLongPress: () async {
                  await Log.deleteLog(context, category, list, index);
                  _init();
                }),
          );
        },
      ),
    );
  }
}
