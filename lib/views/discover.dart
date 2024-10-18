import 'package:flutter/material.dart';

import '../imports/models.dart';
import '../imports/utils.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  final List<Genre> _selectedGenres = [];

  void _toggleGenre(Genre genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('O que quer olhar hoje?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            children: Genre.values.map((genre) {
              return ChoiceChip(
                label: Text(genre.name),
                selected: _selectedGenres.contains(genre),
                selectedColor: CustomTheme.redSecondary,
                onSelected: (selected) {
                  _toggleGenre(genre);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
