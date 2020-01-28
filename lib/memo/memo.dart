import 'package:poodo/data.dart';

class Memo extends Data {
  int id;
  String title;
  String content;

  Memo({this.id, this.title, this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
