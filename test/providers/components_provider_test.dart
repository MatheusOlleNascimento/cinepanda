import 'package:flutter_test/flutter_test.dart';

import 'package:cine_panda/imports/providers.dart';

void main() {
  test('Deve mudar o índice corretamente e notificar ouvintes', () {
    // Cria uma instância do ComponentsProvider
    final componentsProvider = ComponentsProvider();

    // Escuta as mudanças no provider
    componentsProvider.addListener(() {
      // Verifica se o índice mudou corretamente
      expect(componentsProvider.currentIndex, 2);
    });

    // Altera o índice
    componentsProvider.changeIndex(2);

    // Verifica o índice atual
    expect(componentsProvider.currentIndex, 2);
  });

  test('Deve manter o índice inicial como 1', () {
    // Cria uma instância do ComponentsProvider
    final componentsProvider = ComponentsProvider();

    // Verifica o índice inicial
    expect(componentsProvider.currentIndex, 1);
  });
}
