import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../imports/models.dart';
import '../imports/providers.dart';
import '../imports/utils.dart';
import '../imports/styles.dart';
import '../imports/views.dart';
import '../imports/components.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, required this.movieId});
  final int movieId;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    bool favoriteStatus = await context.read<DatabaseProvider>().checkFavorite(widget.movieId);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  Future<void> _changeFavoriteStatus(BuildContext context, Movie movie, DatabaseProvider moviesProvider) async {
    if (isFavorite) {
      await moviesProvider.removeFavorite(movie.id);
      isFavorite = false;
    } else {
      await moviesProvider.addFavorite(movie);
      isFavorite = true;
    }
  }

  Future<void> _launchTrailer(bool existTrailer, String? trailerKey) async {
    if (existTrailer) {
      await launchUrl(Uri.parse('https://www.youtube.com/watch?v=$trailerKey'));
    }
  }

  Widget _trailersButton(bool existTrailer, String? trailerKey) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _launchTrailer(existTrailer, trailerKey),
        child: Card(
          color: existTrailer ? CustomTheme.red : CustomTheme.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(existTrailer ? Icons.play_arrow : Icons.videocam_off_rounded, size: 20, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  existTrailer ? 'Assistir trailer' : 'Trailer indisponível',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _favoriteButton(Movie movie) {
    return Expanded(
      child: Consumer<DatabaseProvider>(
        builder: (context, moviesProvider, child) {
          return GestureDetector(
            onTap: () => _changeFavoriteStatus(context, movie, moviesProvider),
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
    );
  }

  Widget _movieTitle(MovieDetails movie) {
    return Padding(
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
          _avaliation(movie.voteAverage),
        ],
      ),
    );
  }

  Widget _movieDateAndRuntime(MovieDetails movie) {
    return Padding(
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
    );
  }

  Widget _movieGenres(MovieDetails movie) {
    return Padding(
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
    );
  }

  Widget _movieOverview(MovieDetails movie) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(movie.overview, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _movieProviders(List<MovieProvider> providers) {
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
                    context.watch<TheMovieDBProvider>().getProviderLogoUrl(provider.logoPath),
                    width: 60,
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _avaliation(double voteAverage) {
    return voteAverage > 0
        ? Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.star, size: 20, color: Colors.yellow),
              const SizedBox(width: 5),
              Text(
                voteAverage.toStringAsFixed(1),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LogoAppbar(),
      body: FutureBuilder(
        future: context.watch<TheMovieDBProvider>().fetchMovieDetails(context, widget.movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Não foi possível carregar as informações do filme selecionado'));
          } else {
            final movie = snapshot.data;

            return Consumer<ConnectivityProvider>(
              builder: (context, connectivity, child) {
                if (!connectivity.isOnline) return const Center(child: OfflineScreen());

                final existTrailer = movie!.trailerKey != null;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListView(
                    children: <Widget>[
                      Image.network(context.watch<TheMovieDBProvider>().getImageUrl(movie.posterPath), height: 500, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _trailersButton(existTrailer, movie.trailerKey),
                            _favoriteButton(movie),
                          ],
                        ),
                      ),
                      _movieTitle(movie),
                      _movieDateAndRuntime(movie),
                      _movieGenres(movie),
                      _movieOverview(movie),
                      FutureBuilder(
                        future: context.watch<TheMovieDBProvider>().fetchWatchProviders(context, movie.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final providers = snapshot.data;
                          if (providers == null || providers.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return _movieProviders(providers);
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
