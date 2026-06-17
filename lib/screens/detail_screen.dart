import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../utils/constants.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: movie.backdropPath.isNotEmpty
                  ? Image.network(
                      '${Constants.backdropBaseUrl}${movie.backdropPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.movie, size: 100, color: Colors.white),
                    )
                  : const Center(child: Icon(Icons.movie, size: 100, color: Colors.white)),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Consumer<MovieProvider>(
                          builder: (context, provider, child) {
                            final isFav = provider.isFavorite(movie.id);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () => provider.toggleFavorite(movie),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          movie.releaseDate,
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 100), // Spacing at bottom
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
