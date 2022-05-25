import 'package:anotacoes_de_atividades/bloc/task_bloc.dart';
import 'package:anotacoes_de_atividades/bloc/task_events_bloc.dart';
import 'package:anotacoes_de_atividades/bloc/task_states_bloc.dart';
import 'package:anotacoes_de_atividades/models/task_model.dart';
import 'package:bloc_test/bloc_test.dart';


import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import 'mocks/sqflite_mock.dart';


// Unit test with SqfliteMock
void main() async {
  SqfliteMock db = SqfliteMock();
  TaskBloc? bloc;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    await db.createDatabase();
  });

  group("Action bloc:", () {
    setUp(() => bloc = TaskBloc(db: db));
    tearDown(() => bloc!.close());

    blocTest<TaskBloc, TaskStates>("Create Task, OK!",
        build: () => bloc!,
        act: (bloc) => bloc.add(TaskCreateEvent(
            instance: TaskModel(
                title: "title", description: "description", completed: 0))),
        wait: const Duration(seconds: 1),
        expect: () => [isA<TaskSucessState>()],
        verify: (_) async {
          // print(await db.listTasks());
        });

    blocTest<TaskBloc, TaskStates>("Edit Task, OK!",
        build: () => bloc!,
        act: (bloc) async {
          List bancoDeDados = await db.loadTasks();
          TaskModel task = TaskModel.fromJson(bancoDeDados[0]);
          task.title = "TÍTULO ALTERADO";
          return bloc.add(
            TaskEditEvent(instance: task),
          );
        },
        wait: const Duration(seconds: 2),
        expect: () => [isA<TaskSucessState>()],
        verify: (_) async {
          // print(bloc?.allTasksList[0]);
          // print(await db.listTasks());
        });
    blocTest<TaskBloc, TaskStates>("Load Tasks, OK!",
        build: () => bloc!,
        act: (bloc) => bloc.add(TaskLoadEvent()),
        wait: const Duration(seconds: 2),
        expect: () => [isA<TaskSucessState>()]);

    blocTest<TaskBloc, TaskStates>("Completed task, OK!",
        build: () => bloc!,
        act: (bloc) async {
          List bancoDeDados = await db.loadTasks();
          TaskModel task = TaskModel.fromJson(bancoDeDados[0]);
          task.completed = 1;
          return bloc.add(
            TaskEditEvent(instance: task),
          );
        },
        wait: const Duration(seconds: 2),
        expect: () => [isA<TaskSucessState>()],
        verify: (_) async {
          // print(bloc?.allTasksList[0]);
          // print(await db.listTasks());
        });

    blocTest<TaskBloc, TaskStates>("Delete task, OK!",
        build: () => bloc!,
        act: (bloc) async {
          return bloc.add(
            TaskDeleteEvent(id: 0),
          );
        },
        wait: const Duration(seconds: 2),
        expect: () => [isA<TaskSucessState>()],
        verify: (_) async {});
  });

}
