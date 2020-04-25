import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:poodo/todo/todo.dart';
import 'package:poodo/account_credential.dart';

class EventList {
  List<Todo> list;

  List<Todo> referenceList() {
    return list;
  }

  static Future<List<Todo>> getCalendarEvents() async {
    List<Todo> list = [];

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

        // googole calendar event id is 0
        list.add(new Todo(id: 0, content: tmpContent, date: dateUnixTime));
        print(list[list.length - 1].content);
      }
    });

    if (list != null) {
      list.sort((a, b) => a.date.compareTo(b.date));
    }

    return list;
  }
}
