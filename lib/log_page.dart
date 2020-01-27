import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/expense.dart';
import 'package:poodo/log.dart';

class LogPage extends StatefulWidget {
  final DateTime _date;

  LogPage(this._date);

  @override
  _LogPageState createState() => _LogPageState(_date);
}

class _LogPageState extends State<LogPage> {
  final DateTime _date;
  List<Expense> _listFood;
  List<Expense> _listDailyuse;
  List<Expense> _listHealthcare;
  List<Expense> _listLuxury;

  _LogPageState(this._date);

  void _init() async {
    _listFood = Log.getLogAtDay('food', _date);
    _listDailyuse = Log.getLogAtDay('dailyuse', _date);
    _listHealthcare = Log.getLogAtDay('healthcare', _date);
    _listLuxury = Log.getLogAtDay('luxury', _date);

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
          title: Text(_date.toString()),
          actions: <Widget>[
            Icon(Icons.keyboard_arrow_left),
            Icon(Icons.keyboard_arrow_right),
            Icon(Icons.calendar_today),
          ],
        ),
        body: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Text('Total'),
              Text(''),
            ]),
            Row(children: <Widget>[
              FlatButton(
                child: Text('food'),
                onPressed: () {},
              ),
              FlatButton(
                child: Text('daily use'),
                onPressed: () {},
              ),
              FlatButton(
                child: Text('health care'),
                onPressed: () {},
              ),
              FlatButton(
                child: Text('luxury'),
                onPressed: () {},
              ),
            ]),
            Row(
              children: <Widget>[
                Container(child: _expenseItemList(_listFood)),
                Container(child: _expenseItemList(_listDailyuse)),
                Container(child: _expenseItemList(_listHealthcare)),
                Container(child: _expenseItemList(_listLuxury)),
              ],
            ),
          ],
        ));
  }

  Widget _expenseItemList(List<Expense> list) {
    return Container(
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      list[index].cost.toString(),
                      // highlight expired item
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              onTap: () {
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
