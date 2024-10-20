import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'imports/database.dart';
import 'imports/providers.dart';
import 'imports/styles.dart';
import 'imports/views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  await dbHelper.getFavorites();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TheMovieDBProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => ComponentsProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        title: 'CinePanda',
        theme: CustomTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
