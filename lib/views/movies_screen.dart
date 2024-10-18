import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../imports/styles.dart';
import '../imports/models.dart';
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
  List<Movie> _filteredMovies = [];

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
    super.dispose();
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
            if (moviesProvider.movies.isEmpty) {
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
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Pesquise por um filme',
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
                                        const Icon(Icons.arrow_circle_left_rounded, size: 30),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Página ${_listPage - 1}',
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
                        }

                        if (index >= 0) {
                          final movieIndex = index - (showBackButton ? 1 : 0);
                          if (movieIndex < itemCount) {
                            final movie = _filteredMovies[movieIndex];

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
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Skeletonizer(
                                          enabled: moviesProvider.isLoading,
                                          child: Image.network(
                                            moviesProvider.getImageUrl(movie.posterPath),
                                            fit: BoxFit.cover,
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Skeletonizer(
                                                  enabled: true,
                                                  child: Container(
                                                    color: Colors.grey[300],
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
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
      },
    );
  }
}
