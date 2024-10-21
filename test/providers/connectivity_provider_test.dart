import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cine_panda/imports/providers.dart';

void main() {
  // Inicializa o binding do Flutter para testes
  TestWidgetsFlutterBinding.ensureInitialized();

  late ConnectivityProvider connectivityProvider;

  setUp(() {
    connectivityProvider = ConnectivityProvider();
  });

  test('Deve notificar mudança para offline', () {
    // Simula a mudança de conectividade para offline
    connectivityProvider.simulateConnectivityChange([ConnectivityResult.none]);

    // Verifica se o estado é offline
    expect(connectivityProvider.isOnline, false);
  });

  test('Deve notificar mudança para online', () {
    // Simula a mudança de conectividade para online
    connectivityProvider.simulateConnectivityChange([ConnectivityResult.mobile]);

    // Verifica se o estado é online
    expect(connectivityProvider.isOnline, true);
  });

  test('Deve ter estado inicial como online', () {
    // Verifica se o estado inicial é online
    expect(connectivityProvider.isOnline, true);
  });
}
