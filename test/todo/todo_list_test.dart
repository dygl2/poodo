import 'package:flutter_test/flutter_test.dart';

import 'package:poodo/todo/todo.dart';
import 'package:poodo/todo/todo_list.dart';

void main() {
  TodoList todoList;

  setUp(() {
    todoList = TodoList(<Todo>[
      Todo(id: 1, content: "test1", date: 1),
      Todo(id: 2, content: "test2", date: 2),
      Todo(id: 3, content: "test3", date: 3),
    ]);
  });

  group('TodoList add test', () {
    test('initial data', () {
      expect(todoList.length(), 3);
    });

    test('add 1 data', () {
      todoList.add();
      expect(todoList.length(), 4);
    });

    test('delete 1 data', () {
      todoList.delete(2);
      expect(todoList.length(), 2);
    });

    test('get first data', () {
      Todo data = todoList.reference(0);
      expect(data.id, 1);
      expect(data.content, "test1");
      expect(data.date, 1);
    });
  });
}
