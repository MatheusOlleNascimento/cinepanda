import 'package:cine_panda/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../imports/models.dart';
import '../imports/providers.dart';
import '../imports/styles.dart';
import '../imports/utils.dart';
import '../imports/views.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

void _navigateToMovieDetails(BuildContext context, int movieId) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movieId)));
}

Widget _searchBar(Function(String) onChanged) {
  return TextField(
    onChanged: onChanged,
    style: const TextStyle(color: Colors.white),
    decoration: const InputDecoration(
      hintText: 'Pesquise nos seus favoritos',
      hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      suffixIcon: Icon(Icons.search, color: Colors.white),
      fillColor: CustomTheme.blackSecondary,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
  );
}

Widget _notFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/sleeping.svg', semanticsLabel: 'Ops...', width: 240),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Parece que você ainda não adicionou nenhum filme como favorito',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget _favorites(AsyncSnapshot<List<Movie>> snapshot, String searchQuery) {
  final favoriteMovies = snapshot.data!.where((movie) => movie.title.toLowerCase().contains(searchQuery)).toList();

  return ListView.builder(
    itemCount: favoriteMovies.length,
    itemBuilder: (context, index) {
      final movie = favoriteMovies[index];
      return Consumer<TheMovieDBProvider>(
        builder: (context, moviesProvider, child) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.network(
                  moviesProvider.getImageUrl(movie.posterPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(movie.title),
            onTap: () => _navigateToMovieDetails(context, movie.id),
          ),
        ),
      );
    },
  );
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String searchQuery = '';

  void _shareFavorites() async {
    final favoriteMovies = await context.read<DatabaseProvider>().getFavorites();
    if (favoriteMovies.isEmpty) {
      snackbar(context, 'Nenhum filme favorito para compartilhar');
      return;
    }

    var link = compactFavorites(favoriteMovies);
    var message = favoriteShareMessage(link);

    Clipboard.setData(ClipboardData(text: message)).then((_) {
      snackbar(context, 'Link copiado para a área de transferência');
    });
  }

  void _importFavorites() async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Importar Favoritos'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Cole aqui o código ou link',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final input = controller.text.trim();

                if (input.isEmpty) {
                  snackbar(context, 'Cole o link para importar');
                  return;
                }

                try {
                  final data = extractCompactString(input);
                  final favoriteMovies = decompressFavorites(data);

                  if (favoriteMovies.isEmpty) {
                    snackbar(context, 'Nenhum filme encontrado para importar');
                  } else {
                    await context.read<DatabaseProvider>().addFavorites(favoriteMovies);
                    snackbar(context, '${favoriteMovies.length} filmes importados com sucesso');
                    Navigator.pop(context);
                  }
                } catch (e) {
                  snackbar(context, 'Erro ao importar favoritos. Verifique o código');
                }
              },
              child: const Text('Importar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (!connectivity.isOnline) {
          return const Center(child: OfflineScreen());
        }
        return Consumer<TheMovieDBProvider>(
          builder: (context, moviesProvider, child) => Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Column(
              children: [
                _searchBar((value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _importFavorites,
                      icon: const Icon(Icons.download),
                      label: const Text('Importar'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        _shareFavorites();
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Consumer<DatabaseProvider>(
                    builder: (context, moviesProvider, child) => FutureBuilder<List<Movie>>(
                      future: context.read<DatabaseProvider>().getFavorites(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Não foi possível carregar a lista de favoritos'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _notFound();
                        } else {
                          return _favorites(snapshot, searchQuery);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
