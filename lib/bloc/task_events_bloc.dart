import 'package:anotacoes_de_atividades/models/task_model.dart';

abstract class TaskEvents {}

class TaskLoadEvent implements TaskEvents {}

class TaskCreateEvent implements TaskEvents {
  TaskModel instance;

  TaskCreateEvent({required this.instance});
}

class TaskEditEvent implements TaskEvents {
  late TaskModel instance;
  TaskEditEvent({required this.instance});
}

class TaskCompletedEvent implements TaskEvents {
  TaskModel instance;
  bool completed;
  TaskCompletedEvent({required this.instance, required this.completed});
}

class TaskDeleteEvent implements TaskEvents {
  late int id;
  TaskDeleteEvent({required this.id});
}
