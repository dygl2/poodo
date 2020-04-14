import 'package:flutter_test/flutter_test.dart';

import 'package:poodo/todo/TodoList.dart';

void main() {
  TodoList todoList;

  setUp(() {
    todoList = TodoList(<Todo>[
      Todo(1, "test1", 1),
      Todo(2, "test2", 2),
      Todo(3, "test3", 3),
    ]);
  });

  group('TodoList add test', () {
    test('initial data', () {
      expect(todoList.length(), 3);
    });

    test('add 1 data' () {
      todoList.add(Todo(4, "test4", 4));
      expect(todoList.length(), 4);
    });
  });
}
