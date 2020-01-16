import 'package:poodo/data.dart';

class Want extends Data {
  int id;
  String title;
  String content;

  Want({this.id, this.title, this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
