import 'package:anotacoes_de_atividades/interface/helper_interface.dart';
import 'package:anotacoes_de_atividades/models/task_model.dart';


class DatabaseMock implements HelperInterface {
  List<Map<String, dynamic>> database = [];

  @override
  Future deleteTask(int id) async {
    try {
      database.removeAt(id);
      return database;
    } catch (e) {
      return database;
    }
  }

  @override
  Future editTask(TaskModel instance) async {
    instance.id = instance.id;
    database[instance.id! - 1] = instance.toJson();
    return true;
  }

  @override
  Future createTask(TaskModel instance) async {
    var json = instance.toJson();
    json['id'] = database.isEmpty ? 1 : (database.length + 1);
    database.add(json);
    // Retorna o indice do objeto adicionado
    return instance.id;
  }

  @override
  Future loadTasks() async {
    return database;
  }
}
