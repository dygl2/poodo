import 'package:poodo/data.dart';

class Todo extends Data {
  int id;
  String content;
  int date;

  Todo({this.id, this.content, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date,
    };
  }

  bool isEvent() {
    if (id == 0) {
      return true;
    }
    return false;
  }

  bool isPastDate() {
    if (DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(date))) {
      return true;
    }
    return false;
  }
}
