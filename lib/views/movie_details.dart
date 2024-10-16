import 'package:cine_panda/providers/movies_provider.dart';
import 'package:cine_panda/providers/widgets_provider.dart';
import 'package:cine_panda/widgets/logo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieId = context.watch<WidgetsProvider>().selectedMovieId;

    return Scaffold(
      appBar: const LogoAppbar(),
      body: FutureBuilder(
        future: context.watch<MoviesProvider>().fetchMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os detalhes do filme'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Filme não encontrado'));
          } else {
            final movie = snapshot.data;

            return ListView(
              children: <Widget>[
                Image.network(context.watch<MoviesProvider>().getImageUrl(movie!.posterPath), width: 200, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(movie.overview, style: const TextStyle(fontSize: 16)),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
