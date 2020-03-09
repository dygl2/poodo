import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:poodo/db_provider.dart';
import 'package:poodo/todo/edit_todo_page.dart';
import 'package:poodo/todo/todo.dart';
import 'package:poodo/log/log_page.dart';
import 'package:poodo/account_credential.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final String type = "todo";
  List<Todo> _listTodo = [];
  int _index = 0;

  Future<List<Todo>> _getCalendarEvents() async {
    List<Todo> list = [];

    //clientViaServiceAccount(accountCredentials, _scopes).then((client) {
    //var calendar = new GoogleCalendar.CalendarApi(client);
    //var calEvents = calendar.events.list("t0m013h@gmail.com");
    //calEvents.then((GoogleCalendar.Events events) {
    //events.items.forEach((GoogleCalendar.Event event) {

    http.Response response = await http.get(
        "https://www.googleapis.com/calendar/v3/calendars/" +
            calendarId +
            "/events?key=" +
            apiKey);

    DateTime date;
    //if (event.start.dateTime != null) {
    //date = event.start.dateTime;
    //} else {
    //date = event.end.date;
    //}
    Map data = json.decode(response.body);

    List<Map> tmpData = data['items'].cast<Map>() as List<Map>;

    tmpData.forEach((Map m) {
      Map start = m['start'];
      Map end = m['end'];
      if (start['dateTime'] != null) {
        date = DateTime.parse(start['dateTime']);
      } else {
        date = DateTime.parse(end['date']);
      }
      if (!date.isBefore(
          DateTime.now().add(DateTime.now().timeZoneOffset).toUtc())) {
        int dateUnixTime = date.millisecondsSinceEpoch;
        //String tmpContent = event.summary;
        String tmpContent = m['summary'];

        list.add(new Todo(
            id: DateTime.now().millisecondsSinceEpoch,
            content: tmpContent,
            date: dateUnixTime));
        print(list[list.length - 1].content);
      }
    });

    //});
    //});
    //});

    if (list != null) {
      list.sort((a, b) => a.date.compareTo(b.date));
    }

    return list;
  }

  void _init() async {
    _listTodo = await DbProvider().getTodoAll();
    listEvents = await _getCalendarEvents();
    _listTodo.addAll(listEvents);
    _listTodo.sort((a, b) => a.date.compareTo(b.date));
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _add();
          },
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: ListView.builder(
                itemCount: _listTodo.length,
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
                              _listTodo[index].content,
                              // highlight expired item
                              style: TextStyle(
                                  color: DateTime.now().isBefore(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              _listTodo[index].date))
                                      ? Colors.black
                                      : Colors.redAccent),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              DateFormat.yMMMd().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      _listTodo[index].date)),
                              // highlight expired item
                              style: TextStyle(
                                  color: DateTime.now().isBefore(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              _listTodo[index].date))
                                      ? Colors.black
                                      : Colors.redAccent),
                            ),
                          ),
                          Container(
                            width: 40,
                            child: InkWell(
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.redAccent,
                              ),
                              onTap: () {
                                setState(() {
                                  DbProvider()
                                      .delete(type, _listTodo[index].id);
                                  _listTodo.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _edit(_listTodo[index], index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  void _add() {
    setState(() {
      _index = _listTodo.length;
      int id = DateTime.now().millisecondsSinceEpoch;
      Todo todo = new Todo(
          id: id, content: "", date: DateTime.now().millisecondsSinceEpoch);
      DbProvider().insert(type, todo);
      _listTodo.add(todo);

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditTodoPage(todo, _onChanged);
      }));
    });
  }

  void _edit(Todo todo, int index) {
    setState(() {
      _index = index;

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditTodoPage(todo, _onChanged);
      }));
    });
  }

  void _onChanged(Todo todo) {
    setState(() {
      _listTodo[_index].id = todo.id;
      _listTodo[_index].content = todo.content;
      _listTodo[_index].date = todo.date;

      DbProvider().update(type, todo, _listTodo[_index].id);
    });
  }
}
