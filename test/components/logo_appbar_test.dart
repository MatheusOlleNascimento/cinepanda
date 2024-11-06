import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:cine_panda/imports/components.dart';

void main() {
  testWidgets('LogoAppbar deve renderizar corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: LogoAppbar(),
        ),
      ),
    );

    // Verifica se a AppBar está presente
    expect(find.byType(AppBar), findsOneWidget);

    // Verifica se o logo SVG está presente
    expect(find.byType(SvgPicture), findsOneWidget);

    // Verifica se o SVG tem o label correto
    final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svgPicture.semanticsLabel, 'CinePanda');

    // Verifica a altura do AppBar
    expect(tester.getSize(find.byType(AppBar)).height, 56.0);
  });
}
