import 'package:anotacoes_de_atividades/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    final icon = find.byIcon(Icons.add_task_rounded);
    expect(icon, findsOneWidget);

    final text = find.text('Lista de tarefas');
    expect(text, findsOneWidget);

    final listTask = find.byType(CircularProgressIndicator);
    expect(listTask, findsOneWidget);

  });
}
