// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anotacoes_de_atividades/models/task_model.dart';

abstract class TaskStates {
  List<TaskModel> tasks;

  TaskStates({
    required this.tasks,
  });
}

class TaskInitialState extends TaskStates {

  TaskInitialState() : super(tasks: []);
}

class TaskSucessState extends TaskStates {
  TaskSucessState({required super.tasks});
}

