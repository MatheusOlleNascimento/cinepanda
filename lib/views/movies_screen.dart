import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../imports/styles.dart';
import '../imports/providers.dart';
import '../imports/views.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  int _listPage = 1;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TheMovieDBProvider>(context, listen: false).fetchMovies(_listPage);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      if (query.isNotEmpty) {
        Provider.of<TheMovieDBProvider>(context, listen: false).searchMovies(query, _listPage);
      } else {
        Provider.of<TheMovieDBProvider>(context, listen: false).fetchMovies(_listPage);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    Provider.of<TheMovieDBProvider>(context, listen: false).fetchMovies(_listPage);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (!connectivity.isOnline) {
          return const OfflineScreen();
        }

        return Consumer<TheMovieDBProvider>(
          builder: (context, moviesProvider, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Pesquise por um filme',
                      hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () => _onSearchChanged,
                      ),
                      fillColor: CustomTheme.blackSecondary,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 10),
                  if (moviesProvider.movies.isEmpty && !moviesProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Nenhum filme encontrado',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _clearSearch,
                            child: const Text('Limpar busca'),
                          ),
                        ],
                      ),
                    ),
                  if (moviesProvider.movies.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: moviesProvider.movies.length + 1, // incluindo botões de paginação
                        itemBuilder: (context, index) {
                          if (index < moviesProvider.movies.length) {
                            final movie = moviesProvider.movies[index];
                            return GestureDetector(
                              onTap: () {
                                Provider.of<ComponentsProvider>(context, listen: false).changeSelectedMovieId(movie.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MovieDetailsScreen()),
                                );
                              },
                              child: GridTile(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    moviesProvider.getImageUrl(movie.posterPath),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Skeletonizer(
                                          enabled: true,
                                          child: Container(color: Colors.grey[300]),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                          // Exibe o botão "próxima página" no final da lista de filmes
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _listPage++;
                              });
                              Provider.of<TheMovieDBProvider>(context, listen: false).fetchMovies(_listPage);
                            },
                            child: GridTile(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  color: CustomTheme.blackSecondary,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.arrow_circle_right_rounded, size: 30),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Página ${_listPage + 1}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
