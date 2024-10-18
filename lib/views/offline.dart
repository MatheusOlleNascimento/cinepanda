import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/died.svg', semanticsLabel: 'Sem conexão', width: 240),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Parece que você está sem conexão com a internet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
