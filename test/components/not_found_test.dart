import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cine_panda/imports/components.dart';

void main() {
  testWidgets('NotFoundComponent deve renderizar corretamente', (WidgetTester tester) async {
    bool clearSearchCalled = false;

    // Função mock para verificar se é chamada
    void mockClearSearch() {
      clearSearchCalled = true;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotFoundComponent(onClearSearch: mockClearSearch),
        ),
      ),
    );

    // Verifica se o SVG está presente
    expect(find.byType(SvgPicture), findsOneWidget);

    // Verifica se o texto está presente
    expect(find.text('Ainda não temos o filme que você busca na nossa lista'), findsOneWidget);

    // Verifica se o botão "Limpar busca" está presente
    expect(find.text('Limpar busca'), findsOneWidget);

    // Clica no botão "Limpar busca"
    await tester.tap(find.text('Limpar busca'));
    await tester.pumpAndSettle(); // Aguarda a animação

    // Verifica se a função onClearSearch foi chamada
    expect(clearSearchCalled, isTrue);
  });
}
