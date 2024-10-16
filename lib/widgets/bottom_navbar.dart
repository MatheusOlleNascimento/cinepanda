import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cine_panda/providers/widgets_provider.dart';
import 'package:provider/provider.dart';

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
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(icon: LineIcons.home, text: 'Início'),
              GButton(icon: LineIcons.heart, text: 'Favoritos'),
              GButton(icon: LineIcons.random, text: 'Mê surpreenda'),
            ],
            selectedIndex: Provider.of<WidgetsProvider>(context).currentIndex,
            onTabChange: (index) {
              Provider.of<WidgetsProvider>(context, listen: false).changeIndex(index);
            },
          ),
        ),
      ),
    );
  }
}
