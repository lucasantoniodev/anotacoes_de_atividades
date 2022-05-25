import 'package:anotacoes_de_atividades/interface/helper_interface.dart';
import 'package:anotacoes_de_atividades/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteMock implements HelperInterface {
  Database? database;
  // Table Struct
  String tableName = 'TABLE_TASK';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colCompleted = 'completed';

  createDatabase() async {
    database = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE $tableName ('
          '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
          '$colTitle Text, '
          '$colDescription Text, '
          '$colCompleted INTEGER)');
    });
  }

  @override
  Future<int> createTask(TaskModel object) async {
    Database db =
        database!; // Selecionando o banco de dados que vai cadastrar a tarefa

    int result =
        await db.insert(tableName, object.toJson()); // Retorna um inteiro

    return result;
  }

  // List tasks
  @override
  Future loadTasks() async {
    Database db = database!;
    String sql = "SELECT * FROM $tableName";

    List tasks = await db.rawQuery(sql);
    return tasks;
  }

  // Edit tasks
  @override
  Future<int> editTask(TaskModel object) async {
    Database db = database!;

    int result = await db.update(tableName, object.toJson(),
        where: "id = ?", whereArgs: [object.id]);

    return result;
  }

  // Delete tasks
  @override
  Future<int> deleteTask(int id) async {
    Database db = database!;

    int result = await db.delete(tableName, where: "id = ?", whereArgs: [id]);

    return result;
  }
}
