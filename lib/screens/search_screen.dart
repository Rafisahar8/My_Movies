import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        Provider.of<MovieProvider>(context, listen: false).searchMovies(query);
      } else {
        Provider.of<MovieProvider>(context, listen: false).clearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      Provider.of<MovieProvider>(context, listen: false).clearSearch();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (query) {
            setState(() {});
            _onSearchChanged(query);
          },
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (_searchController.text.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Search for movies',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          if (provider.searchResults.isEmpty) {
            return const Center(
              child: Text(
                'No movies found.',
                style: TextStyle(color: Colors.grey, fontSize: 18),
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
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final movie = provider.searchResults[index];
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
