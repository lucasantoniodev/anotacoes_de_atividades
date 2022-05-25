import 'package:anotacoes_de_atividades/models/task_model.dart';

abstract class HelperInterface {
  createTask(TaskModel instance);
  editTask(TaskModel instance);
  loadTasks();
  deleteTask(int id);
}
