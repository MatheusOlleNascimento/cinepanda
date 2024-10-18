import 'package:cine_panda/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imports/models.dart';
import '../imports/providers.dart';
import '../imports/utils.dart';
import '../imports/views.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (context, moviesProvider, child) => Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Column(
          children: [
            // Campo de pesquisa
            TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase(); // Atualiza o texto da pesquisa
                });
              },
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
            ),
            const SizedBox(height: 10), // Espaço entre o campo de pesquisa e a lista
            Expanded(
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
                    final favoriteMovies = snapshot.data!.where((movie) => movie.title.toLowerCase().contains(searchQuery)).toList(); // Filtra a lista de filmes com base na pesquisa

                    return ListView.builder(
                      itemCount: favoriteMovies.length,
                      itemBuilder: (context, index) {
                        final movie = favoriteMovies[index];
                        return Consumer<MoviesProvider>(
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
                              onTap: () {
                                Provider.of<WidgetsProvider>(context, listen: false).changeSelectedMovieId(movie.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MovieDetailsPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
