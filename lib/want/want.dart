import 'package:poodo/data.dart';

class Want extends Data {
  int id;
  String title;
  int number;
  String content;

  Want({this.id, this.title, this.number, this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'number': number,
      'content': content,
    };
  }
}
