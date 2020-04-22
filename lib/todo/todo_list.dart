import 'package:poodo/todo/todo.dart';

class TodoList {
  List<Todo> list;

  TodoList(this.list);

  int length() {
    return list.length;
  }

  void add(Todo todo) {
    list.add(todo);
  }

  Todo reference(int index) {
    return new Todo(
        id: list[index].id,
        content: list[index].content,
        date: list[index].date);
  }

  void delete(int index) {
    list.removeAt(index);
  }

  void update(Todo newData, int index) {
    list[index].id = newData.id;
    list[index].content = newData.content;
    list[index].date = newData.date;
  }
}
