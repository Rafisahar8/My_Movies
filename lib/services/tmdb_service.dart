import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../utils/constants.dart';

class TmdbService {
  final String _apiKey = Constants.apiKey;
  final String _baseUrl = Constants.baseUrl;

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final List results = json.decode(response.body)['results'];
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('API Key tidak valid.');
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getPopularMovies: $e');
      throw Exception('Koneksi Gagal: Periksa internet Anda.');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=${Uri.encodeComponent(query)}'),
      );

      if (response.statusCode == 200) {
        final List results = json.decode(response.body)['results'];
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Gagal mencari film');
      }
    } catch (e) {
      print('Error searchMovies: $e');
      throw Exception('Koneksi Gagal: Periksa internet Anda.');
    }
  }

  Future<Movie> getMovieDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$id?api_key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        return Movie.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat detail film');
      }
    } catch (e) {
      print('Error getMovieDetail: $e');
      throw Exception('Koneksi Gagal: Periksa internet Anda.');
    }
  }
}
