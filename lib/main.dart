import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/movie_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/favorite_screen.dart';
import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: const MyMoviesApp(),
    ),
  );
}

class MyMoviesApp extends StatelessWidget {
  const MyMoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMovies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.detail: (context) => const DetailScreen(),
        AppRoutes.search: (context) => const SearchScreen(),
        AppRoutes.favorite: (context) => const FavoriteScreen(),
      },
    );
  }
}
