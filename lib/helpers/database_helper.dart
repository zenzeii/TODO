import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:TODO/models/todo_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String todoTables = 'todo_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colStatus = 'status';
  String colPriority = 'priority';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $todoTables($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colStatus INTEGER, $colPriority INTEGER)');
  }

  Future<List<Map<String, dynamic>>> gettodoMapList() async {
    Database db = (await this.db)!;
    final List<Map<String, dynamic>> result = await db.query(todoTables);
    return result;
  }

  Future<int> getLenList() async {
    final List<Map<String, dynamic>> todoMapList = await gettodoMapList();
    return todoMapList.length;
  }

  Future<List<Todo>> getTodoList() async {
    final List<Map<String, dynamic>> todoMapList = await gettodoMapList();
    final List<Todo> todoList = [];
    todoMapList.forEach((todoMap) {
      todoList.add(Todo.fromMap(todoMap));
    });
    todoList.sort((a, b) => a.priority.compareTo(b.priority));
    return todoList;
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = (await this.db)!;
    final int result = await db.insert(todoTables, todo.toMap());
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = (await this.db)!;
    final int result = await db.update(todoTables, todo.toMap(),
        where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    Database db = (await this.db)!;
    final int result =
        await db.delete(todoTables, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
