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
}
