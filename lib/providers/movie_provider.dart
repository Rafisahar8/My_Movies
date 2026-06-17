import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieProvider with ChangeNotifier {
  final TmdbService _tmdbService = TmdbService();
  List<Movie> _popularMovies = [];
  List<Movie> _searchResults = [];
  List<Movie> _favoriteMovies = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get searchResults => _searchResults;
  List<Movie> get favoriteMovies => _favoriteMovies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  MovieProvider() {
    loadFavorites();
  }

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _popularMovies = await _tmdbService.getPopularMovies();
    } catch (e) {
      _errorMessage = 'Gagal memuat film. Cek koneksi internet atau API Key Anda.';
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _searchResults = await _tmdbService.searchMovies(query);
    } catch (e) {
      _errorMessage = 'Pencarian gagal.';
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteList = prefs.getStringList('favorites');
    if (favoriteList != null) {
      _favoriteMovies = favoriteList
          .map((item) => Movie.fromJson(json.decode(item)))
          .toList();
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(Movie movie) async {
    final index = _favoriteMovies.indexWhere((m) => m.id == movie.id);
    if (index >= 0) {
      _favoriteMovies.removeAt(index);
    } else {
      _favoriteMovies.add(movie);
    }
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoriteList =
        _favoriteMovies.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('favorites', favoriteList);
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return _favoriteMovies.any((m) => m.id == movieId);
  }
}
