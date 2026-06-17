import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchPopularMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'MyMovies',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favorite),
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchPopularMovies(),
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          }

          if (provider.popularMovies.isEmpty) {
            return const Center(
              child: Text('Tidak ada film ditemukan', style: TextStyle(color: Colors.white)),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.popularMovies.length,
            itemBuilder: (context, index) {
              final movie = provider.popularMovies[index];
              return MovieCard(
                movie: movie,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detail,
                    arguments: movie,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
