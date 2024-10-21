import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../imports/components.dart';
import '../imports/models.dart';
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
      Provider.of<TheMovieDBProvider>(context, listen: false).fetchPopularMovies(context, _listPage);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String? query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (query != null && query.isNotEmpty) {
        setState(() {
          _listPage = 1;
        });
        Provider.of<TheMovieDBProvider>(context, listen: false).fetchPMovies(context, query, 1);
      } else {
        Provider.of<TheMovieDBProvider>(context, listen: false).fetchPopularMovies(context, _listPage);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    Provider.of<TheMovieDBProvider>(context, listen: false).fetchPopularMovies(context, _listPage);
  }

  void _returnPage() {
    setState(() {
      _listPage--;
    });
    if (_searchController.text.isNotEmpty) {
      Provider.of<TheMovieDBProvider>(context, listen: false).fetchPMovies(context, _searchController.text, _listPage);
    } else {
      Provider.of<TheMovieDBProvider>(context, listen: false).fetchPopularMovies(context, _listPage);
    }
  }

  void _nextPage() {
    setState(() {
      _listPage++;
    });
    if (_searchController.text.isNotEmpty) {
      Provider.of<TheMovieDBProvider>(context, listen: false).fetchPMovies(context, _searchController.text, _listPage);
    } else {
      Provider.of<TheMovieDBProvider>(context, listen: false).fetchPopularMovies(context, _listPage);
    }
  }

  Widget _searchBar() {
    return TextField(
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
    );
  }

  Widget _cardMovie(Movie movie, TheMovieDBProvider moviesProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movie.id)),
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
    );
  }

  Widget _returnButton(Function() onPressed) {
    return GestureDetector(
      onTap: () => _returnPage,
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

  Widget _nextButton(Function() onPressed) {
    return GestureDetector(
      onTap: () => _nextPage,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (!connectivity.isOnline) {
          return const OfflineScreen();
        }

        bool showBackButton = _listPage > 1;

        return Consumer<TheMovieDBProvider>(
          builder: (context, moviesProvider, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Column(
                children: [
                  _searchBar(),
                  const SizedBox(height: 10),
                  if (moviesProvider.movies.isEmpty && !moviesProvider.isLoading) NotFoundComponent(onClearSearch: _clearSearch),
                  if (moviesProvider.movies.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: moviesProvider.movies.length + 1,
                        itemBuilder: (context, index) {
                          if (showBackButton && index == 0) {
                            return _returnButton(_returnPage);
                          }
                          if (index < moviesProvider.movies.length) {
                            final movie = moviesProvider.movies[index];
                            return _cardMovie(movie, moviesProvider);
                          }
                          if (moviesProvider.movies.length > 19 && _searchController.text.isEmpty) {
                            return _nextButton(_nextPage);
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
