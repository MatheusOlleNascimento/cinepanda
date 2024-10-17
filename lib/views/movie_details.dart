import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../imports/providers.dart';
import '../imports/utils.dart';
import '../imports/views.dart';
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
            return Consumer<ConnectivityProvider>(
              builder: (context, connectivity, child) {
                if (!connectivity.isOnline) {
                  return const Center(child: OfflinePage());
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListView(
                    children: <Widget>[
                      Image.network(
                        context.watch<MoviesProvider>().getImageUrl(movie!.posterPath),
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Card(
                                color: CustomTheme.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_arrow, size: 20),
                                      SizedBox(width: 5),
                                      Text('Assistir trailer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Consumer<MoviesProvider>(
                                builder: (context, moviesProvider, child) {
                                  final isFavorite = moviesProvider.isFavorite(movie.id);

                                  return GestureDetector(
                                    onTap: () async {
                                      if (isFavorite) {
                                        await moviesProvider.removeFavorite(movie.id);
                                      } else {
                                        await moviesProvider.addFavorite(movie);
                                      }
                                      await moviesProvider.checkFavorite(movie.id);
                                    },
                                    child: Card(
                                      color: CustomTheme.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              isFavorite ? Icons.favorite : Icons.favorite_border,
                                              size: 20,
                                              color: isFavorite ? Colors.red : Colors.white,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              isFavorite ? 'Desfavoritar' : 'Favoritar',
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
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
                                const SizedBox(width: 20),
                                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(formatRuntime(movie.runtime), style: const TextStyle(fontSize: 16, color: Colors.grey)),
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
                        padding: const EdgeInsets.all(15),
                        child: Text(movie.overview, style: const TextStyle(fontSize: 16)),
                      ),
                      FutureBuilder(
                        future: context.watch<MoviesProvider>().fetchWatchProviders(movie.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final providers = snapshot.data;
                          if (providers == null || providers.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Onde assistir',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: providers.map(
                                    (provider) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          context.watch<MoviesProvider>().getProviderLogoUrl(provider.logoPath),
                                          width: 60,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
