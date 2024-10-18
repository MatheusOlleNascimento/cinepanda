import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../imports/styles.dart';

class NotFoundComponent extends StatelessWidget {
  final VoidCallback onClearSearch;

  const NotFoundComponent({super.key, required this.onClearSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/sad.svg', semanticsLabel: 'Triste', height: 180),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Text(
                'Ainda não temos o filme que você busca na nossa lista',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: onClearSearch,
              child: Card(
                color: CustomTheme.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Limpar busca',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
