import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onde_assistir/viewmodels/view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModel()),
      ],
      child: MaterialApp(
        title: 'Onde Assistir',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.red,
            onPrimary: Colors.white,
            inversePrimary: Colors.black,
          ),
        ),
        home: const MyHomePage(title: 'Filmes'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewModel>(context, listen: false).fetchMovies(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Consumer<ViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.movies.isEmpty) {
              return const Center(child: Text('Nenhum filme encontrado'));
            }
            return ListView.builder(
              itemCount: viewModel.movies.length,
              itemBuilder: (context, index) {
                final movie = viewModel.movies[index];
                return ListTile(
                  leading: Image.network(viewModel.getImageUrl(movie.posterPath)),
                  title: Text(movie.title),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
