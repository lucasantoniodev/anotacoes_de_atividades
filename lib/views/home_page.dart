import 'package:anotacoes_de_atividades/bloc/task_bloc.dart';
import 'package:anotacoes_de_atividades/bloc/task_events_bloc.dart';
import 'package:anotacoes_de_atividades/bloc/task_states_bloc.dart';
import 'package:anotacoes_de_atividades/components/custom_alert_dialog_component.dart';
import 'package:anotacoes_de_atividades/helpers/task_helper.dart';

import 'package:anotacoes_de_atividades/models/task_model.dart';
import 'package:anotacoes_de_atividades/widgets/custom_text_button_widget.dart';
import 'package:anotacoes_de_atividades/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late TaskBloc bloc;

  @override
  void initState() {
    bloc = TaskBloc(db: TaskHelper());
    bloc.add(TaskLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lista de tarefas',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 31, 4, 107),
        actions: [
          IconButton(
              onPressed: () {
                addTaskDialog();
              },
              icon: const Icon(
                Icons.add_task_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder(
              bloc: bloc,
              builder: (context, state) {
                if (state is TaskSucessState) {
                  final listOfInstaces = state.tasks;
                  Text(listOfInstaces.toString());

                  return ListView.separated(
                    itemCount: listOfInstaces.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      bool? taskState;
                      if (listOfInstaces[index].completed == 1) {
                        taskState = true;
                      } else {
                        taskState = false;
                      }
                      return Card(
                        color: taskState
                            ? const Color.fromARGB(255, 143, 226, 137)
                            : Colors.grey[400],
                        child: ListTile(
                          leading: Checkbox(
                              value: taskState,
                              onChanged: (value) {
                                bloc.add(TaskCompletedEvent(
                                    instance: state.tasks[index],
                                    completed: value!));
                              }),
                          title: Text(
                            listOfInstaces[index].title,
                            style: taskState
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough)
                                : null,
                          ),
                          subtitle: Text(
                            listOfInstaces[index].description,
                            style: taskState
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough)
                                : null,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    editTaskDialog(listOfInstaces[index]);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                onPressed: () {
                                  deleteTaskDialog(listOfInstaces[index].id!);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is TaskInitialState) {
                  return const CircularProgressIndicator();
                } else {
                  return const Center(child: Text('Lista vazia'));
                }
              }),
        ),
      ),
    );
  }

  addTaskDialog() {
    _titleController.text = "";
    _descriptionController.text = "";
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialogComponent(
              actionTitle: "Adicionar nova tarefa",
              widgets: [
                CustomTextFieldWidget(
                  focus: true,
                  controller: _titleController,
                  title: 'Name',
                ),
                CustomTextFieldWidget(
                  controller: _descriptionController,
                  title: 'Descrição',
                )
              ],
              actionsWidgets: [
                CustomTextButtonWidget(
                  onPressed: () {
                    bloc.add(
                      TaskCreateEvent(
                        instance: TaskModel(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            completed: 0),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  actionText: "Criar",
                  color: Colors.green,
                ),
                CustomTextButtonWidget(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  actionText: "Cancelar",
                ),
              ],
            ));
  }

  editTaskDialog(TaskModel instance) {
    _titleController.text = instance.title;
    _descriptionController.text = instance.description;
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialogComponent(actionTitle: "Editar tarefa", widgets: [
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: 'Name', hintText: 'Digite o título da tarefa'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Descrição', hintText: 'Descrição da tarefa'),
              )
            ], actionsWidgets: [
              TextButton(
                  onPressed: () {
                    instance.title = _titleController.text;
                    instance.description = _descriptionController.text;
                    bloc.add(TaskEditEvent(instance: instance));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Editar",
                    style: TextStyle(color: Colors.green),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.blue),
                  ))
            ]));
  }

  deleteTaskDialog(int id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Excluir Tarefa",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Você tem certeza que deseja excluir?",
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      bloc.add(TaskDeleteEvent(id: id));
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Excluir",
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.purple),
                    )),
              ],
            ));
  }
}
