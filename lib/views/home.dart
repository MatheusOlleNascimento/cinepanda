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
  final int _listPage = 1;
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

        // Filtrando filmes com base na pesquisa
        _filteredMovies = moviesProvider.movies.where((movie) {
          return movie.title.toLowerCase().contains(_searchController.text.toLowerCase());
        }).toList();

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
                  itemCount: _filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = _filteredMovies[index];
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
                                child: Image.network(moviesProvider.getImageUrl(movie.posterPath), fit: BoxFit.cover),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
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
