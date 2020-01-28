import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/todo/edit_todo_page.dart';
import 'package:poodo/todo/todo.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final String type = "todo";
  DbProvider db = DbProvider();
  List<Todo> _listTodo = [];
  int _index = 0;

  void _init() async {
    await db.database;
    _listTodo = await DbProvider().getTodoAll();

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
