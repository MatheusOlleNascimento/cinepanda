import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cine_panda/imports/components.dart';
import 'package:cine_panda/imports/providers.dart';

void main() {
  // Cria uma função que fornece um mock do provider
  ComponentsProvider createMockProvider() {
    return ComponentsProvider();
  }

  testWidgets('BottomNavbar deve renderizar corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => createMockProvider(),
        child: const MaterialApp(
          home: Scaffold(body: BottomNavbar()),
        ),
      ),
    );

    // Verifica se os botões estão presentes
    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Me surpreenda'), findsOneWidget);
  });
}
