import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imports/providers.dart';
import '../imports/views.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _listPage = 1;

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
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: moviesProvider.movies.length,
            itemBuilder: (context, index) {
              final movie = moviesProvider.movies[index];
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
        );
      },
    );
  }
}
