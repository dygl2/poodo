import 'package:poodo/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:poodo/data.dart';
import 'package:poodo/todo.dart';
import 'package:poodo/memo.dart';
import 'package:poodo/want.dart';
import 'package:poodo/expense.dart';
import 'package:poodo/food.dart';
import 'package:poodo/dailyuse.dart';
import 'package:poodo/healthcare.dart';
import 'package:poodo/luxury.dart';

class DbProvider {
  static Database _db;
  static DbProvider _cache = DbProvider._internal();
  String path = "";

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
        version: 1,
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
                  content TEXT
                )
              """);
          newDb.execute("""
              CREATE TABLE category
                (
                  id INTEGER PRIMARY KEY,
                  category TEXT
                )
              """);
          newDb.execute("""
              CREATE TABLE food
                (
                  id INTEGER PRIMARY KEY,
                  category TEXT,
                  date INTEGER,
                  cost INTEGER,
                  FOREIGN KEY (category) REFERENCES category(id) 
                )
              """);
          newDb.execute("""
              CREATE TABLE dailyuse
                (
                  id INTEGER PRIMARY KEY,
                  category TEXT,
                  date INTEGER,
                  cost INTEGER,
                  FOREIGN KEY (category) REFERENCES category(id) 
                )
              """);
          newDb.execute("""
              CREATE TABLE healthcare
                (
                  id INTEGER PRIMARY KEY,
                  category TEXT,
                  date INTEGER,
                  cost INTEGER,
                  FOREIGN KEY (category) REFERENCES category(id) 
                )
              """);
          newDb.execute("""
              CREATE TABLE luxury
                (
                  id INTEGER PRIMARY KEY,
                  category TEXT,
                  date INTEGER,
                  cost INTEGER,
                  FOREIGN KEY (category) REFERENCES category(id) 
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
    List<Map<String, dynamic>> maps = await _db.query('want');
    return List.generate(maps.length, (i) {
      return Want(
          id: maps[i]['id'],
          title: maps[i]['title'],
          content: maps[i]['content']);
    });
  }

  Future<List<Expense>> getExpenseAll(String category) async {
    List<Map<String, dynamic>> maps = await _db.query(category);
    if (maps != null) {
      return List.generate(maps.length, (i) {
        switch (category) {
          case 'food':
            return Food(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'dailyuse':
            return DailyUse(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'healthcare':
            return HealthCare(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'luxury':
            return Luxury(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
        }
      });
    }
  }

  Future<List<Expense>> getExpense(String category, int index) async {
    List<Map<String, dynamic>> maps =
        await _db.query(category, where: 'id = ?', whereArgs: [index]);
    if (maps != null) {
      return List.generate(maps.length, (i) {
        switch (category) {
          case 'food':
            return Food(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'dailyuse':
            return DailyUse(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'healthcare':
            return HealthCare(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'luxury':
            return Luxury(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
        }
      });
    }
  }

  Future<List<Expense>> getExpenseAtDay(String category, int day) async {
    List<Map<String, dynamic>> maps =
        await _db.query(category, where: 'date = ?', whereArgs: [day]);
    if (maps != null) {
      return List.generate(maps.length, (i) {
        switch (category) {
          case 'food':
            return Food(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'dailyuse':
            return DailyUse(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'healthcare':
            return HealthCare(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'luxury':
            return Luxury(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
        }
      });
    }
  }

  Future<List<Expense>> getExpenseInPeriod(
      String category, int start, int end) async {
    List<Map<String, dynamic>> maps = await _db.query(category,
        where: 'date between = ? AND ?', whereArgs: [start, end]);
    if (maps != null) {
      return List.generate(maps.length, (i) {
        switch (category) {
          case 'food':
            return Food(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'dailyuse':
            return DailyUse(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'healthcare':
            return HealthCare(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
          case 'luxury':
            return Luxury(
                id: maps[i]['id'],
                category: maps[i]['category'],
                date: maps[i]['date'],
                cost: maps[i]['cost']);
        }
      });
    }
  }
}
