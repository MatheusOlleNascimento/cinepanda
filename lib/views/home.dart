import 'package:flutter/material.dart';
import 'package:cine_panda/providers/movies_provider.dart';
import 'package:provider/provider.dart';

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
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (viewModel.movies.isEmpty) {
          return const Center(child: Text('Nenhum filme encontrado'));
        }
        return ListView.builder(
          itemCount: viewModel.movies.length,
          itemBuilder: (context, index) {
            final movie = viewModel.movies[index];
            return ListTile(
              leading: Image.network(viewModel.getImageUrl(movie.posterPath)),
              title: Text(movie.title),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            );
          },
        );
      },
    );
  }
}
