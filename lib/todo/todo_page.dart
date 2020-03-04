import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poodo/db_provider.dart';
import 'package:poodo/todo/edit_todo_page.dart';
import 'package:poodo/todo/todo.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleCalendar;
import 'package:googleapis_auth/auth_io.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final String type = "todo";
  List<Todo> _listTodo = [];
  int _index = 0;

  final accountCredentials = new ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "dygl2-poodo",
    "private_key_id": "0fd36f10737e42c4fcefdb93c75ae84de24e3b31",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCpo8MvDOfC04vT\n55+rVc/17dNPAK4vMKI6Oa4g142RKIKp6JMv01rZC/SZdsd/PZx3vzJJWB914iZv\nMddLCxtB1hxlaYfkxTloLncGtK9EzW2w/pI7T4J46CYi72dW0TMuPq8yu5ix9Lbp\ngwba9qfhF1Ds1lFZdSbLbKezGGkG7tJJc9Idk8Q6pjRAR+O3a4o6a/Maa8/sZ3gF\nPAZUl1IVEoSNMAicXJaXwBih+ZOkb4wsIsTOJx21gkvvtBkhyv7kW0FMDFtFsp22\nnBGm32yR5SHog0vj80SmXdGwLWDSjgv3cBMz4czfmw6ZBPMvagkNQb7Katg47ccl\nPO9QWtubAgMBAAECggEAU3X+HCJxziFNXKrLHD1CbSEewvI3QIFhd1sUiBT1EhNH\nwfdqnu+R9VJT+8L8IOZ7mlCnmX0xMUrcFP4FCedDeE8ytlRG5y9/cHnX1qVDzApz\n6s48vNCABSNWS/7ULVsMnrZ5dPDmDbuz2Ew+LbGH5A8YIgXJjUU9mnzxPwSF+8Hq\nFfJ8BOFGozYRtU2HidHNNv71EypxZa1OiYBTZnISHVoYWewDiyUah/u3UONX5HWo\nonNnM//A8L/uSToK+RrupBCbrmtPu0rxITWpvkE5Xi97leFWtCOsOKuf38pHCq66\nGeW2Q87ave0ltyv45pb577nl9OBwP5Ev8fLulBO94QKBgQDvFfhKNWLFIDYY2qsT\ndGsRy+7vX+/YAog7cQC3TOH6EohkFc4HbCH+fEOtTYPo7Zv/oS0QLOUmZZ8o7V03\nHHQzElaVTa+GYcdq/Wz6sbEJrEVHliJzDpjpAzR4g4eUIEH+CppaaAoiW5ol7jLB\nyx+uSGWRxEVOcqisqfC4ztVRoQKBgQC1pBG7cqjM/Bhb/5VBnManc5B4TvFDbAo2\nP60ahP7I0vfGXB+TDJlM09dZVH59TiaFWD7R63kpm/szi8lwBu+HK7i/Y8lyqTM+\nF3bVBzA9PoRnTVdbyP30RvDEO4FgyjaEGdR4V7F8+dX3a6LofXCnqIViAreybt0S\nKvVBIARbuwKBgQDhVvqqrsCF/QMfz9GYR4y2vFhaIzkChfhy1eIP4ZXHRfppIqgK\nFN/BZMvApqOiQXlbqUS4zye3VeZ6A6Zs0BOxIyKaHBtIdBYpf+xcKGgtLsIpY5ba\njLKQQ+YLhCSf9vtb/hBXD2Il2eJix6vtPY6BjFi2159e/fB+tLle5grmoQKBgFDX\nZMz4iwgwaucHKXa6P+/nDzV8bQSE4UajsHdNGdhnjL9L4QGhadk3r3CimmlKjvpp\n/AuRsatDMNoQLOcfLxwJ6X/E+bN+er/30XueZ2namTMgyPCg0+YUbLPph/t8BCdn\nF5k37lahGwmzbh3rNmhoKHUmoHtZvCqJ0/3YMhhhAoGBAIP94eG/gzM28uNm/m+z\nlF6c+D+OdHMb83IZqLakcsM3WPxFqdkUiHHJn8T16iM4fVqQ3pKyjY9fGUvllhZV\n6rnET6kOpiGSIOPoM2+d61AUlmylHjFn2QyfoZOoZhbe4CbGM3wBdFARjoadEIQ6\nYduGhFMhlTEw53ujAlmoNHj6\n-----END PRIVATE KEY-----\n",
    "client_email": "dygl2-001@dygl2-poodo.iam.gserviceaccount.com",
    "client_id": "107587000322886211467",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/dygl2-001%40dygl2-poodo.iam.gserviceaccount.com"
  });

  var _scopes = [
    GoogleCalendar.CalendarApi.CalendarScope
  ]; //defines the scopes for the calendar api

  Future<void> _getCalendarEvents(List<Todo> list) async {
    await clientViaServiceAccount(accountCredentials, _scopes).then((client) {
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
                id: int.parse(event.iCalUID),
                content: tmpContent,
                date: dateUnixTime));
            print(event.summary);
          }
        });
      });
    });

    list.sort((a, b) => a.date.compareTo(b.date));
  }

  void _init() async {
    _listTodo = await DbProvider().getTodoAll();

    await _getCalendarEvents(_listTodo);

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
