import 'package:cine_panda/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imports/models.dart';
import '../imports/providers.dart';
import '../imports/views.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (context, moviesProvider, child) => Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Movie>>(
          future: DatabaseHelper().getFavorites(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar favoritos'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum favorito encontrado'));
            } else {
              final favoriteMovies = snapshot.data!;
              return ListView.builder(
                itemCount: favoriteMovies.length,
                itemBuilder: (context, index) {
                  final movie = favoriteMovies[index];
                  return Consumer<MoviesProvider>(
                    builder: (context, moviesProvider, child) => ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: SizedBox(
                        width: 50,
                        height: 200,
                        child: Image.network(
                          moviesProvider.getImageUrl(movie.posterPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(movie.title),
                      onTap: () {
                        Provider.of<WidgetsProvider>(context, listen: false).changeSelectedMovieId(movie.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MovieDetailsPage()),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
