import 'package:cine_panda/imports/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imports/models.dart';
import '../imports/providers.dart';
import '../imports/views.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _listPage = 1;
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoviesProvider>(context, listen: false).fetchMovies(_listPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (context, moviesProvider, child) {
        if (moviesProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (moviesProvider.movies.isEmpty) {
          return const Center(child: Text('Nenhum filme encontrado'));
        }

        _filteredMovies = moviesProvider.movies.where((movie) {
          return movie.title.toLowerCase().contains(_searchController.text.toLowerCase());
        }).toList();

        int itemCount = _filteredMovies.length;
        bool showBackButton = _listPage > 1;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar filmes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: itemCount + (showBackButton ? 1 : 0) + 1,
                  itemBuilder: (context, index) {
                    if (showBackButton && index == 0) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _listPage--;
                          });
                          Provider.of<MoviesProvider>(context, listen: false).fetchMovies(_listPage);
                        },
                        child: GridTile(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              color: CustomTheme.black,
                              child: const Center(
                                child: Text(
                                  'Voltar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (index >= 0) {
                      final movieIndex = index - (showBackButton ? 1 : 0);
                      if (movieIndex < itemCount) {
                        final movie = _filteredMovies[movieIndex];
                        return GestureDetector(
                          onTap: () {
                            Provider.of<WidgetsProvider>(context, listen: false).changeSelectedMovieId(movie.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MovieDetailsPage()),
                            );
                          },
                          child: GridTile(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      moviesProvider.getImageUrl(movie.posterPath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }

                    if (index == itemCount + (showBackButton ? 1 : 0)) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _listPage++;
                          });
                          Provider.of<MoviesProvider>(context, listen: false).fetchMovies(_listPage);
                        },
                        child: GridTile(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              color: CustomTheme.black,
                              child: const Center(
                                child: Text(
                                  'Próxima página',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
