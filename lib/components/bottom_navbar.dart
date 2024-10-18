import 'package:cine_panda/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../imports/providers.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomTheme.red,
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: CustomTheme.redSecondary,
            color: Colors.white,
            tabs: const [
              GButton(icon: LineIcons.heart, text: 'Favoritos', textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              GButton(icon: LineIcons.home, text: 'Início', textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              GButton(icon: LineIcons.random, text: 'Mê surpreenda', textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            ],
            selectedIndex: Provider.of<ComponentsProvider>(context).currentIndex,
            onTabChange: (index) {
              Provider.of<ComponentsProvider>(context, listen: false).changeIndex(index);
            },
          ),
        ),
      ),
    );
  }
}
