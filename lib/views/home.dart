import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imports/providers.dart';
import '../imports/views.dart';
import '../imports/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Widget> _tabPagesIndex = <Widget>[
    LikesPage(),
    MoviesPage(),
    DiscoverPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<WidgetsProvider>().currentIndex;

    return Scaffold(
      appBar: const LogoAppbar(),
      body: Center(child: _tabPagesIndex.elementAt(currentIndex)),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
