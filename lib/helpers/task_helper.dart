import 'dart:io';

import 'package:anotacoes_de_atividades/interface/helper_interface.dart';
import 'package:anotacoes_de_atividades/models/task_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TaskHelper implements HelperInterface {
  static TaskHelper? _databaseHelper;

  TaskHelper._createInstance();

  factory TaskHelper() {
    _databaseHelper ??= TaskHelper._createInstance();
    return _databaseHelper!;
  }
  static Database? _database;

  //================ Table Struct ================//
  String tableName = 'TABLE_TASK';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colCompleted = 'completed';

  //================ Database ================//
  void _createDatabase(Database db, int verison) async {
    await db.execute('CREATE TABLE $tableName ('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colTitle Text, '
        '$colDescription Text, '
        '$colCompleted INTEGER)');
  }

  //================ Initialization ================//
  Future<Database> initializationDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}dbtasks.db';

    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);

    return database;
  }

  //================ Initialization checking ================//
  Future<Database> get database async {
    _database ??= await initializationDatabase();
    return _database!;
  }

  //================================ CRUD ================================//

  //================ Create task ================//
  @override
  Future<int> createTask(TaskModel instance) async {
    Database db = await database;
    int result = await db.insert(tableName, instance.toJson());
    return result;
  }

  //================ Load task ================//
  @override
  Future loadTasks() async {
    Database db = await database;
    String sql = "SELECT * FROM $tableName";
    List tasks = await db.rawQuery(sql);

    return tasks;
  }

  //================ Edit task ================//
  @override
  Future<int> editTask(TaskModel instance) async {
    Database db = await database;

    int result = await db.update(tableName, instance.toJson(),
        where: "id = ?", whereArgs: [instance.id]);
    return result;
  }

  //================ Delete task ================//
  @override
  Future<int> deleteTask(int id) async {
    Database db = await database;
    int result = await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }
}
