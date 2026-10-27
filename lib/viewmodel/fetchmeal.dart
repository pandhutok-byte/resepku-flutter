import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/meal.dart';

class FetchMeal {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Mengambil dan memeriksa respons JSON dari API.
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Permintaan API gagal. Kode: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format respons API tidak sesuai.');
    }

    return decoded;
  }

  // Mengambil daftar resep berdasarkan kata kunci.
  Future<List<Meal>> searchMeals(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final uri = Uri.https('www.themealdb.com', '/api/json/v1/1/search.php', {
      's': query.trim(),
    });

    final data = await _getJson(uri);
    final meals = data['meals'] as List<dynamic>? ?? [];

    return meals
        .whereType<Map<String, dynamic>>()
        .map((item) => Meal.fromJson(item))
        .toList();
  }

  // Mengambil daftar kategori makanan.
  Future<List<String>> getCategories() async {
    final uri = Uri.parse('$baseUrl/categories.php');
    final data = await _getJson(uri);

    final categories = data['categories'] as List<dynamic>? ?? [];

    return categories
        .whereType<Map<String, dynamic>>()
        .map((item) => item['strCategory']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  // Mengambil daftar resep berdasarkan kategori.
  Future<List<Meal>> getMealsByCategory(String category) async {
    final uri = Uri.https('www.themealdb.com', '/api/json/v1/1/filter.php', {
      'c': category,
    });

    final data = await _getJson(uri);
    final meals = data['meals'] as List<dynamic>? ?? [];

    return meals
        .whereType<Map<String, dynamic>>()
        .map((item) => Meal.fromJson(item))
        .toList();
  }

  // Mengambil detail resep berdasarkan ID.
  Future<Meal> getMealDetail(String id) async {
    final uri = Uri.https('www.themealdb.com', '/api/json/v1/1/lookup.php', {
      'i': id,
    });

    final data = await _getJson(uri);
    final meals = data['meals'] as List<dynamic>? ?? [];

    if (meals.isEmpty) {
      throw Exception('Resep tidak ditemukan.');
    }

    return Meal.fromJson(meals.first as Map<String, dynamic>);
  }

  // Mengambil satu resep secara acak.
  Future<Meal> getRandomMeal() async {
    final uri = Uri.parse('$baseUrl/random.php');
    final data = await _getJson(uri);

    final meals = data['meals'] as List<dynamic>? ?? [];

    if (meals.isEmpty) {
      throw Exception('Resep acak tidak ditemukan.');
    }

    return Meal.fromJson(meals.first as Map<String, dynamic>);
  }
}
