import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poodo/expense.dart';
import 'package:poodo/log.dart';

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

  _LogPageState(this._date);

  void _init() async {
    _listFood = await Log.getLogAtDay('food', _date);
    _listDailyuse = await Log.getLogAtDay('dailyuse', _date);
    _listHealthcare = await Log.getLogAtDay('healthcare', _date);
    _listLuxury = await Log.getLogAtDay('luxury', _date);

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
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                _date = _date.add(new Duration(days: 1));
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () {
                _setDate(context);
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
                    Text('Total'),
                    Text(''),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                //padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
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
                      child: _expenseItemList(_listFood),
                    ),
                    Expanded(
                      child: _expenseItemList(_listDailyuse),
                    ),
                    Expanded(
                      child: _expenseItemList(_listHealthcare),
                    ),
                    Expanded(
                      child: _expenseItemList(_listLuxury),
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
