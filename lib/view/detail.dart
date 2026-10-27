import 'package:flutter/material.dart';

import '../model/meal.dart';
import '../viewmodel/fetchmeal.dart';

class MealDetailPage extends StatefulWidget {
  final String mealId;

  const MealDetailPage({super.key, required this.mealId});

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  final FetchMeal fetchMeal = FetchMeal();

  late Future<Meal> mealFuture;

  @override
  void initState() {
    super.initState();
    mealFuture = fetchMeal.getMealDetail(widget.mealId);
  }

  void _retry() {
    setState(() {
      mealFuture = fetchMeal.getMealDetail(widget.mealId);
    });
  }

  Widget _infoChip(IconData icon, String label) {
    if (label.isEmpty || label == '-') {
      return const SizedBox.shrink();
    }

    return Chip(
      avatar: Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
      label: Text(label),
      backgroundColor: const Color(0xFFE8F5E9),
      side: BorderSide.none,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIngredients(List<MealIngredient> ingredients) {
    if (ingredients.isEmpty) {
      return const Text('Informasi bahan belum tersedia.');
    }

    return Column(
      children: ingredients.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF2E7D32),
                size: 21,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  ingredient.name,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  ingredient.measure,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetail(Meal meal) {
    final instructions = meal.instructions.trim();
    final tags = meal.tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  meal.imageUrl,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                  webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 260,
                      width: double.infinity,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.restaurant, size: 60),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                meal.name,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF25364A),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _infoChip(Icons.restaurant_menu, meal.category),
                  _infoChip(Icons.public, meal.area),
                ],
              ),
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: Colors.white,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 26),
              _sectionTitle('Bahan-bahan (${meal.ingredients.length})'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildIngredients(meal.ingredients),
              ),
              const SizedBox(height: 28),
              _sectionTitle('Cara memasak'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  instructions.isEmpty
                      ? 'Instruksi memasak belum tersedia.'
                      : instructions,
                  style: const TextStyle(fontSize: 15, height: 1.7),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Resep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Meal>(
        future: mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 14),
                  Text('Memuat detail resep...'),
                ],
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      size: 55,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Detail resep gagal dimuat.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          return _buildDetail(snapshot.data!);
        },
      ),
    );
  }
}
