import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../imports/providers.dart';
import '../imports/utils.dart';
import '../imports/widgets.dart';

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

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListView(
                children: <Widget>[
                  Image.network(
                    context.watch<MoviesProvider>().getImageUrl(movie!.posterPath),
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.star, size: 20, color: Colors.yellow),
                        const SizedBox(width: 5),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                            const SizedBox(width: 10),
                            Builder(
                              builder: (context) {
                                String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(movie.releaseDate));
                                return Text(formattedDate, style: const TextStyle(fontSize: 16, color: Colors.grey));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: movie.genreNames.map((genre) {
                        return Card(
                          color: CustomTheme.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              genre,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(movie.overview, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
