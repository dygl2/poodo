import 'package:flutter/material.dart';
import 'package:poodo/todo.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class EditTodoPage extends StatefulWidget {
  final Todo _todo;
  final Function _onChanged;

  EditTodoPage(this._todo, this._onChanged);

  @override
  _EditTodoPageState createState() => _EditTodoPageState(_todo, _onChanged);
}

class _EditTodoPageState extends State<EditTodoPage> {
  final Todo _todo;
  final Function _onChanged;

  _EditTodoPageState(this._todo, this._onChanged);

  void _init() async {
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Todo'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(Icons.check),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        leading: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios),
          shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        ),
      ),
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  //flex: 4,
                  child: TextField(
                    controller: TextEditingController(text: _todo.content),
                    decoration: InputDecoration(
                      labelText: "things to do",
                    ),
                    maxLines: 2,
                    style: new TextStyle(color: Colors.black),
                    onChanged: (text) {
                      _todo.content = text;
                      _onChanged(_todo);
                    },
                  ),
                ),
                //Expanded(
                //flex: 1,
                //child: IconButton(
                //icon: Icon(Icons.date_range),
                //onPressed: () {
                //_selectDate(context);
                //},
                //)),
              ],
            ),
            CalendarCarousel<Event>(
              onDayPressed: onDayPressed,
              weekendTextStyle: TextStyle(color: Colors.red),
              height: 420,
              selectedDateTime: DateTime.fromMillisecondsSinceEpoch(_todo.date),
              selectedDayBorderColor: Colors.transparent,
              selectedDayButtonColor: Colors.orangeAccent,
              daysHaveCircularBorder: false,
              todayBorderColor: Colors.blue,
              todayButtonColor: Colors.white,
              todayTextStyle: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDayPressed(DateTime date, List<Event> events) {
    this.setState(() {
      _todo.date = date.millisecondsSinceEpoch;
      _onChanged(_todo);
    });
  }

  //Future<void> _selectDate(BuildContext context) async {
  //final DateTime selected = await showDatePicker(
  //context: context,
  //initialDate: DateTime.now(),
  //firstDate: DateTime(2020),
  //lastDate: DateTime(2050),
  //);
  //if (selected != null) {
  //_todo.date = selected.millisecondsSinceEpoch;
  //_onChanged(_todo);
  //}
  //}
}
