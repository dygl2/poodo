import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:poodo/db_provider.dart';
import 'package:poodo/todo/edit_todo_page.dart';
import 'package:poodo/todo/todo.dart';
import 'package:poodo/todo/todo_list.dart';
import 'package:poodo/todo/event_list.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final String type = "todo";
  TodoList _listTodo = new TodoList([]);
  List<Todo> _listEvents = [];
  int _index = 0;

  void _init() async {
    await _listTodo.getTodoAll();
    _listEvents = await EventList.getCalendarEvents();
    _listTodo.addList(_listEvents);
    _listTodo.sort();
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
                itemCount: _listTodo.length(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: _listTodo.reference(index).isEvent()
                        ? Colors.grey[100]
                        : Colors.white,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Text(
                              _listTodo.reference(index).content,
                              // highlight expired item
                              style: TextStyle(
                                  color: _listTodo.reference(index).isPastDate()
                                      ? Colors.black
                                      : Colors.redAccent),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              DateFormat.yMMMd().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      _listTodo.reference(index).date)),
                              // highlight expired item
                              style: TextStyle(
                                  color: _listTodo.reference(index).isPastDate()
                                      ? Colors.black
                                      : Colors.redAccent),
                            ),
                          ),
                          Container(
                            width: 40,
                            child: InkWell(
                              child: Icon(
                                _listTodo.reference(index).isEvent()
                                    ? Icons.calendar_today
                                    : Icons.remove_circle,
                                color: _listTodo.reference(index).isEvent()
                                    ? Colors.black
                                    : Colors.redAccent,
                              ),
                              onTap: () {
                                setState(() {
                                  if (!_listTodo.reference(index).isEvent()) {
                                    DbProvider().delete(
                                        type, _listTodo.reference(index).id);
                                    _listTodo.delete(index);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          if (!_listTodo.reference(index).isEvent()) {
                            _edit(_listTodo.reference(index), index);
                          }
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
      _index = _listTodo.length();
      _listTodo.add();
      DbProvider().insert("todo", _listTodo.reference(_index));

      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return new EditTodoPage(_listTodo.reference(_index), _onChanged);
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
      _listTodo.update(todo, _index);
      DbProvider().update(type, todo, _listTodo.reference(_index).id);
    });
  }
}
