import 'package:anotacoes_de_atividades/bloc/task_bloc.dart';
import 'package:anotacoes_de_atividades/bloc/task_events_bloc.dart';
import 'package:anotacoes_de_atividades/bloc/task_states_bloc.dart';
import 'package:anotacoes_de_atividades/models/task_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/database_mock.dart';

// Unit test with DatabaseMock
void main() {
  DatabaseMock db = DatabaseMock();
  TaskBloc? taskBloc;

  group("BloC Action: ", () {
    setUp(() => taskBloc = TaskBloc(db: db));
    tearDown(() async => await taskBloc!.close());

    blocTest<TaskBloc, TaskStates>(
      "Nova tarefa, OK!",
      build: () => taskBloc!,
      act: (bloc) => bloc.add(TaskCreateEvent(
          instance: TaskModel(
              title: "Criar um APP", description: "TODO LIST", completed: 0))),
      expect: () => [isA<TaskSucessState>()],
    );

    blocTest<TaskBloc, TaskStates>("Editar tarefa, OK!",
        build: () => taskBloc!,
        act: (bloc) {
          db.database[0]['title'] = 'TÍTULO DA TAREFA EDITADO';
          TaskModel instance = TaskModel.fromJson(db.database[0]);
          return bloc.add(TaskEditEvent(instance: instance));
        },
        expect: () => [isA<TaskSucessState>()],
        verify: (bloc) {
          // print(db.database);
        });

    blocTest<TaskBloc, TaskStates>("Carregar Lista, OK!",
        build: () => taskBloc!,
        act: (bloc) => bloc.add(TaskLoadEvent()),
        expect: () => [isA<TaskSucessState>()],
        verify: (bloc) {
          // print("LISTA DE INSTÂNCIA CONSUMIDA PELA UI ${taskBloc!.allTasksList}");
          // print("BANCO DE DADOS: ${db.database[0]}");
        });

    blocTest<TaskBloc, TaskStates>("Deletar tarefa, OK!",
        build: () => taskBloc!,
        act: (bloc) {
          return bloc.add(TaskDeleteEvent(id: 0));
        },
        expect: () => [isA<TaskSucessState>()],
        verify: (bloc) {
          // print(db.database);
        });
  });

  group("BloC Action:", () {
    setUp(() => taskBloc = TaskBloc(db: db));
    tearDown(() async => await taskBloc!.close());

    blocTest<TaskBloc, TaskStates>(
      "Nova tarefa, OK!",
      build: () => taskBloc!,
      act: (bloc) => bloc.add(TaskCreateEvent(
          instance: TaskModel(
              title: "Criar um APP 2",
              description: "TODO LIST 2",
              completed: 0))),
      expect: () => [isA<TaskSucessState>()],
    );

    blocTest<TaskBloc, TaskStates>("Concluir tarefa, OK!",
        build: () => taskBloc!,
        act: (bloc) {
          TaskModel instance = TaskModel.fromJson(db.database[0]);
          return bloc
              .add(TaskCompletedEvent(instance: instance, completed: true));
        },
        expect: () => [isA<TaskSucessState>()],
        verify: (bloc) {
          // print(db.database[0]);
        });
  });
}
