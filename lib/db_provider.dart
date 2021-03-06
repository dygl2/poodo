import 'package:poodo/log/condition_log.dart';
import 'package:poodo/log/log_category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:poodo/data.dart';
import 'package:poodo/todo/todo.dart';
import 'package:poodo/memo/memo.dart';
import 'package:poodo/want/want.dart';
import 'package:poodo/log/expense.dart';
import 'package:poodo/log/food.dart';
import 'package:poodo/log/dailyuse.dart';
import 'package:poodo/log/healthcare.dart';
import 'package:poodo/log/luxury.dart';

class DbProvider {
  static Database _db;
  static DbProvider _cache = DbProvider._internal();
  String path = "";
  DateFormat _format = DateFormat('yyyy-MM-dd', 'ja');

  factory DbProvider() {
    return _cache;
  }
  DbProvider._internal();

  Future<Database> get database async {
    if (_db == null) {
      //dbDir = await getDatabasesPath();
      Directory dbDir = await getExternalStorageDirectory();
      path = join(dbDir.path, "poodo.db");

      _db = await openDatabase(
        path,
        version: 4,
        onCreate: (Database newDb, int version) {
          newDb.execute("""
              CREATE TABLE todo
                (
                  id INTEGER PRIMARY KEY,
                  content TEXT,
                  date INTEGER
                )
              """);
          newDb.execute("""
              CREATE TABLE memo
                (
                  id INTEGER PRIMARY KEY,
                  title TEXT,
                  content TEXT
                )
              """);
          newDb.execute("""
              CREATE TABLE want
                (
                  id INTEGER PRIMARY KEY,
                  title TEXT,
                  number INTEGER,
                  content TEXT
                )
              """);
          newDb.execute("""
              CREATE TABLE category
                (
                  id INTEGER PRIMARY KEY,
                  category INTEGER
                )
              """);
          newDb.execute("""
              CREATE TABLE food
                (
                  id INTEGER PRIMARY KEY,
                  category INTEGER,
                  date INTEGER,
                  cost INTEGER,
                  remarks TEXT,
                  FOREIGN KEY (category) REFERENCES category(id) 
                )
              """);
          newDb.execute("""
              CREATE TABLE dailyuse
                (
                  id INTEGER PRIMARY KEY,
                  category INTEGER,
                  date INTEGER,
                  cost INTEGER,
                  remarks TEXT,
                  FOREIGN KEY (category) REFERENCES category(id) 
                )
              """);
          newDb.execute("""
              CREATE TABLE healthcare
                (
                  id INTEGER PRIMARY KEY,
                  category INTEGER,
                  date INTEGER,
                  cost INTEGER,
                  remarks TEXT,
                  FOREIGN KEY (category) REFERENCES category(id) 
                )
              """);
          newDb.execute("""
              CREATE TABLE luxury
                (
                  id INTEGER PRIMARY KEY,
                  category INTEGER,
                  date INTEGER,
                  cost INTEGER,
                  remarks TEXT,
                  FOREIGN KEY (category) REFERENCES category(id) 
                )
              """);
          newDb.execute("""
              CREATE TABLE condition
                (
                  id INTEGER PRIMARY KEY,
                  date String,
                  category INTEGER,
                  condition INTEGER
                )
              """);
        },
      );
    }

    return _db;
  }

  Future<void> clearDB() async {
    deleteDatabase(path);
  }

  Future<int> insert(String tableName, Data data) async {
    return await _db.insert(tableName, data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(String tableName, int index) async {
    await _db.delete(tableName, where: 'id = ?', whereArgs: [index]);
  }

  Future<void> update(String tableName, Data data, int index) async {
    await _db
        .update(tableName, data.toMap(), where: 'id = ?', whereArgs: [index]);
  }

  Future<List<Todo>> getTodo(int index) async {
    List<Map<String, dynamic>> maps =
        await _db.query('todo', where: 'id = ?', whereArgs: [index]);
    return List.generate(maps.length, (i) {
      return Todo(
          id: maps[i]['id'],
          content: maps[i]['content'],
          date: maps[i]['date']);
    });
  }

  Future<List<Memo>> getMemo(int index) async {
    List<Map<String, dynamic>> maps =
        await _db.query('memo', where: 'id = ?', whereArgs: [index]);
    return List.generate(maps.length, (i) {
      return Memo(
          id: maps[i]['id'],
          title: maps[i]['title'],
          content: maps[i]['content']);
    });
  }

  Future<List<Want>> getWant(int index) async {
    List<Map<String, dynamic>> maps =
        await _db.query('want', where: 'id = ?', whereArgs: [index]);
    return List.generate(maps.length, (i) {
      return Want(
          id: maps[i]['id'],
          title: maps[i]['title'],
          number: maps[i]['number'],
          content: maps[i]['content']);
    });
  }

  Future<List<Todo>> getTodoAll() async {
    // query sorted todo list in ascending order
    List<Map<String, dynamic>> maps =
        await _db.query('todo', orderBy: 'date ASC');
    return List.generate(maps.length, (i) {
      return Todo(
          id: maps[i]['id'],
          content: maps[i]['content'],
          date: maps[i]['date']);
    });
  }

  Future<List<Memo>> getMemoAll() async {
    List<Map<String, dynamic>> maps = await _db.query('memo');
    return List.generate(maps.length, (i) {
      return Memo(
          id: maps[i]['id'],
          title: maps[i]['title'],
          content: maps[i]['content']);
    });
  }

  Future<List<Want>> getWantAll() async {
    List<Map<String, dynamic>> maps =
        await _db.query('want', orderBy: 'number ASC');
    return List.generate(maps.length, (i) {
      return Want(
          id: maps[i]['id'],
          title: maps[i]['title'],
          number: maps[i]['number'],
          content: maps[i]['content']);
    });
  }

  Future<List<Expense>> getExpenseAll(LogCategory category) async {
    List<Map<String, dynamic>> maps =
        await _db.query(category.toString().split('.')[1]);
    if (maps != null) {
      return List.generate(maps.length, (i) {
        switch (LogCategory.values[category.index]) {
          case LogCategory.food:
            return Food(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.dailyuse:
            return DailyUse(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.healthcare:
            return HealthCare(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.luxury:
            return Luxury(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
        }
      });
    }
  }

  Future<List<Expense>> getExpense(LogCategory category, int index) async {
    List<Map<String, dynamic>> maps = await _db.query(
        category.toString().split('.')[1],
        where: 'id = ?',
        whereArgs: [index]);
    if (maps != null) {
      return List.generate(maps.length, (i) {
        switch (LogCategory.values[category.index]) {
          case LogCategory.food:
            return Food(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.dailyuse:
            return DailyUse(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.healthcare:
            return HealthCare(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.luxury:
            return Luxury(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
        }
      });
    }
  }

  Future<List<Expense>> getExpenseInPeriod(
      LogCategory category, int start, int end) async {
    List<Map<String, dynamic>> maps = await _db.rawQuery("select * from " +
        category.toString().split('.')[1] +
        " where date>=" +
        start.toString() +
        " and date<" +
        end.toString());
    if (maps != null) {
      return List.generate(maps.length, (i) {
        switch (LogCategory.values[category.index]) {
          case LogCategory.food:
            return Food(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.dailyuse:
            return DailyUse(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.healthcare:
            return HealthCare(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
          case LogCategory.luxury:
            return Luxury(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost'],
                remarks: maps[i]['remarks']);
        }
      });
    }
  }

  Future<List<ConditionLog>> getConditionLog(
      DateTime date, ConditionCategory category) async {
    List<Map<String, dynamic>> maps = await _db.rawQuery(
        "select * from condition" +
            " where date = '" +
            _format.format(date) +
            "' and category = " +
            category.index.toString());
    if (maps != null && maps.length > 0) {
      return List.generate(maps.length, (i) {
        return ConditionLog(
            id: maps[i]['id'],
            date: maps[i]['date'],
            category: maps[i]['category'],
            condition: maps[i]['condition']);
      });
    } else {
      insert(
          'condition',
          ConditionLog(
              id: DateTime.now().millisecondsSinceEpoch,
              date: _format.format(date),
              category: category.index,
              condition: Condition.MODERATELY_GOOD.index));
      return List.generate(
          1,
          (_) => ConditionLog(
              id: DateTime.now().millisecondsSinceEpoch,
              date: _format.format(date),
              category: category.index,
              condition: Condition.MODERATELY_GOOD.index));
    }
  }
}
