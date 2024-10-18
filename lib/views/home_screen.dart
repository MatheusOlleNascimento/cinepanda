import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imports/providers.dart';
import '../imports/views.dart';
import '../imports/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final List<Widget> _tabPagesIndex = <Widget>[
    const FavoritesScreen(),
    const MoviesScreen(),
    const DiscoverMoviesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<ComponentsProvider>().currentIndex;

    return Scaffold(
      appBar: const LogoAppbar(),
      body: Center(child: _tabPagesIndex.elementAt(currentIndex)),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
