import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../utils/routes.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Favorite Movies',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.favoriteMovies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, color: Colors.grey, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
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
            itemCount: provider.favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = provider.favoriteMovies[index];
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
