import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cine_panda/imports/components.dart';

void main() {
  testWidgets('snackbar deve exibir mensagem correta', (WidgetTester tester) async {
    // Cria um MaterialApp para fornecer o contexto
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  snackbar(context, 'Mensagem de teste');
                },
                child: const Text('Mostrar Snackbar'),
              );
            },
          ),
        ),
      ),
    );

    // Clica no botão para exibir o Snackbar
    await tester.tap(find.text('Mostrar Snackbar'));
    await tester.pumpAndSettle(); // Aguarda a animação

    // Verifica se o SnackBar está sendo exibido com a mensagem correta
    expect(find.text('Mensagem de teste'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
