import 'package:anotacoes_de_atividades/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  TaskModel task =
      TaskModel(title: "title", description: "description", completed: 1);

  group("Classe TaskModel", () {
    test("Aprovado", () {
      expect("title", task.title);
      expect("description", task.description);
      expect(1, task.completed);
    });
  });
}
