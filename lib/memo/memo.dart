import 'package:poodo/data.dart';

class Memo extends Data {
  int id;
  String title;
  int number;
  String content;

  Memo({this.id, this.title, this.number, this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'number': number,
      'content': content,
    };
  }
}
