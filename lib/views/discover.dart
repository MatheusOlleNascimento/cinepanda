import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../imports/providers.dart';
import '../imports/utils.dart';
import '../imports/views.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoviesProvider>(context, listen: false).fetchDiscoverMovies(Random().nextInt(20) + 1);
    });
  }

  final List<Map<String, String>> variations = [
    {'image': 'assets/hero.svg', 'text': 'Está sem ideia? Deixe comigo!', 'button': '⚔️ Pesquisar'},
    {'image': 'assets/zoombie.svg', 'text': 'Assistir filmes é melhor do que morder cérebros! Vamos lá!', 'button': '🧠 Pesquisar'},
    {'image': 'assets/cowboy.svg', 'text': 'Sinto um vento de dúvida no ar!', 'button': '🤠 Pesquisar'},
    {'image': 'assets/doctor.svg', 'text': 'Um bom filme é o melhor remédio!', 'button': '💉 Pesquisar'},
  ];

  @override
  Widget build(BuildContext context) {
    final randomVariation = (variations.toList()..shuffle()).first;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SvgPicture.asset(
                randomVariation['image']!,
                semanticsLabel: 'CinePanda',
                height: 240,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  randomVariation['text']!,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () {
                    var trendingMovies = Provider.of<MoviesProvider>(context, listen: false).trendingMovies;

                    if (trendingMovies.isNotEmpty) {
                      var randomIndex = Random().nextInt(trendingMovies.length);
                      var randomTrendingMovie = trendingMovies[randomIndex];

                      Provider.of<WidgetsProvider>(context, listen: false).changeSelectedMovieId(randomTrendingMovie.id);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MovieDetailsPage()),
                      );
                    }
                  },
                  child: Card(
                    color: CustomTheme.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            randomVariation['button']!,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
