import 'package:cine_panda/utils/theme.dart';
import 'package:cine_panda/views/home.dart';
import 'package:cine_panda/widgets/logo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cine_panda/providers/movies_provider.dart';
import 'package:cine_panda/providers/widgets_provider.dart';
import 'package:cine_panda/views/discover.dart';
import 'package:cine_panda/views/likes.dart';
import 'package:cine_panda/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider()),
        ChangeNotifierProvider(create: (_) => WidgetsProvider()),
      ],
      child: MaterialApp(
        title: 'CinePanda',
        theme: CustomTheme.darkTheme,
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<Widget> _tabPagesIndex = <Widget>[
    HomePage(),
    LikesPage(),
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
