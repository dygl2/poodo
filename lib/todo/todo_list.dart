import 'package:poodo/db_provider.dart';
import 'package:poodo/todo/todo.dart';

class TodoList {
  List<Todo> list;

  TodoList(this.list);

  void getTodoAll() async {
    list = await DbProvider().getTodoAll();
  }

  void sort() {
    list.sort((a, b) => a.date.compareTo(b.date));
  }

  int length() {
    return list.length;
  }

  void add() {
    int id = DateTime.now().millisecondsSinceEpoch;
    Todo todo = new Todo(
        id: id, content: "", date: DateTime.now().millisecondsSinceEpoch);
    list.add(todo);
  }

  void addList(List<Todo> addedList) {
    list.addAll(addedList);
  }

  Todo reference(int index) {
    return new Todo(
        id: list[index].id,
        content: list[index].content,
        date: list[index].date);
  }

  List<Todo> referenceList() {
    return list;
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
