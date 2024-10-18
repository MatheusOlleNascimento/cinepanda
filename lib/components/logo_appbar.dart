import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoAppbar extends StatelessWidget implements PreferredSizeWidget {
  const LogoAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: SvgPicture.asset('assets/logo.svg', semanticsLabel: 'CinePanda', height: 40),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
