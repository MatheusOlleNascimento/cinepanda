import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../imports/utils.dart';

class DiscoverPage extends StatelessWidget {
  DiscoverPage({super.key});

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
                  onTap: () {},
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
