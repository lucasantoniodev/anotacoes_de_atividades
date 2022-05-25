import 'package:anotacoes_de_atividades/models/task_model.dart';
import 'package:bloc/bloc.dart';

import 'package:anotacoes_de_atividades/bloc/task_events_bloc.dart';
import 'package:anotacoes_de_atividades/bloc/task_states_bloc.dart';
import 'package:anotacoes_de_atividades/interface/helper_interface.dart';

class TaskBloc extends Bloc<TaskEvents, TaskStates> {
  HelperInterface db;
  List<TaskModel> allTasksList = [];

  TaskBloc({required this.db}) : super(TaskInitialState()) {
    on<TaskLoadEvent>(loadlist);
    on<TaskCreateEvent>(createNewTask);
    on<TaskEditEvent>(editTask);
    on<TaskCompletedEvent>(completedTask);
    on<TaskDeleteEvent>(deleteTask);
  }

  //================ Update list ================//
  upadateList() async {
    List allTasks = await db.loadTasks();
    List<TaskModel> temporaryList = [];
    for (var task in allTasks) {
      temporaryList.add(TaskModel.fromJson(task));
    }

    allTasksList = temporaryList;

    temporaryList = [];
    // print(allTasksList);
  }

  //================ Load list ================//
  loadlist(TaskLoadEvent event, Emitter emit) async {
    await upadateList();
    emit(TaskSucessState(tasks: allTasksList));
  }

  //================ Create new task ================//
  createNewTask(TaskCreateEvent event, Emitter emit) async {
    await db.createTask(event.instance);
    await upadateList();
    emit(TaskSucessState(tasks: allTasksList));
  }

  //================ Edit task ================//
  editTask(TaskEditEvent event, Emitter emit) async {
    await db.editTask(event.instance);
    await upadateList();
    emit(TaskSucessState(tasks: allTasksList));
  }

  //================ Completed task ================//
  completedTask(TaskCompletedEvent event, Emitter emit) async {
    event.completed
        ? event.instance.completed = 1
        : event.instance.completed = 0;

    await db.editTask(event.instance);
    await upadateList();
    emit(TaskSucessState(tasks: allTasksList));
  }

  //================ Delete task ================//
  deleteTask(TaskDeleteEvent event, Emitter emit) async {
    await db.deleteTask(event.id);
    await upadateList();
    emit(TaskSucessState(tasks: allTasksList));
  }
}
