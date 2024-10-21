import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cine_panda/imports/database.dart';
import 'package:cine_panda/imports/models.dart';

void main() async {
  late DatabaseHelper databaseHelper;
  late Database database;

  // Configuração do ambiente de teste
  setUpAll(() async {
    // Inicializa o FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Inicializa a classe DatabaseHelper
    databaseHelper = DatabaseHelper();
    database = await databaseHelper.database;

    // Cria a tabela de favoritos se não existir
    await database.execute(
      'CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY, title TEXT, posterPath TEXT)',
    );
  });

  tearDownAll(() async {
    // Fecha o banco de dados após os testes
    await database.close();
  });

  setUp(() async {
    // Limpa a tabela favorites antes de cada teste
    await database.execute('DELETE FROM favorites');
  });

  test('Deve adicionar um filme aos favoritos', () async {
    final movie = Movie(id: 1, title: 'Teste Movie', posterPath: 'test/path.jpg');

    await databaseHelper.addFavorite(movie);

    final favorites = await databaseHelper.getFavorites();
    expect(favorites.length, 1);
    expect(favorites.first.title, 'Teste Movie');
  });

  test('Deve remover um filme dos favoritos', () async {
    final movie = Movie(id: 1, title: 'Teste Movie', posterPath: 'test/path.jpg');
    await databaseHelper.addFavorite(movie);

    await databaseHelper.removeFavorite(movie.id);

    final favorites = await databaseHelper.getFavorites();
    expect(favorites.length, 0);
  });

  test('Deve retornar se o filme é favorito', () async {
    final movie = Movie(id: 1, title: 'Teste Movie', posterPath: 'test/path.jpg');
    await databaseHelper.addFavorite(movie);

    final isFavorite = await databaseHelper.isFavorite(movie.id);
    expect(isFavorite, true);

    await databaseHelper.removeFavorite(movie.id);
    final isStillFavorite = await databaseHelper.isFavorite(movie.id);
    expect(isStillFavorite, false);
  });

  test('Deve retornar a lista de filmes favoritos', () async {
    final movie1 = Movie(id: 1, title: 'Teste Movie 1', posterPath: 'test/path1.jpg');
    final movie2 = Movie(id: 2, title: 'Teste Movie 2', posterPath: 'test/path2.jpg');

    await databaseHelper.addFavorite(movie1);
    await databaseHelper.addFavorite(movie2);

    final favorites = await databaseHelper.getFavorites();
    expect(favorites.length, 2);
    expect(favorites[0].title, 'Teste Movie 1');
    expect(favorites[1].title, 'Teste Movie 2');
  });
}
