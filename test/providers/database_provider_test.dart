import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cine_panda/imports/models.dart';
import 'package:cine_panda/imports/providers.dart';
import 'package:cine_panda/imports/database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DatabaseProvider databaseProvider;
  late DatabaseHelper databaseHelper;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    databaseHelper = DatabaseHelper();
    databaseProvider = DatabaseProvider();

    // Cria a tabela de favoritos
    final database = await databaseHelper.database;
    await database.execute(
      'CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY, title TEXT, posterPath TEXT)',
    );
  });

  tearDownAll(() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movies.db');
    await deleteDatabase(path); // Excluir o banco de dados
  });

  test('Deve adicionar um filme aos favoritos', () async {
    final movie = Movie(id: 1, title: 'Teste Movie', posterPath: 'test/path.jpg');

    await databaseProvider.addFavorite(movie);

    final isFavorite = await databaseProvider.checkFavorite(movie.id);
    expect(isFavorite, true);
  });

  test('Deve remover um filme dos favoritos', () async {
    final movie = Movie(id: 1, title: 'Teste Movie', posterPath: 'test/path.jpg');
    await databaseProvider.addFavorite(movie);

    await databaseProvider.removeFavorite(movie.id);

    final isFavorite = await databaseProvider.checkFavorite(movie.id);
    expect(isFavorite, false);
  });

  test('Deve verificar se um filme é favorito', () async {
    final movie = Movie(id: 1, title: 'Teste Movie', posterPath: 'test/path.jpg');
    await databaseProvider.addFavorite(movie);

    final isFavorite = await databaseProvider.checkFavorite(movie.id);
    expect(isFavorite, true);
  });
}
