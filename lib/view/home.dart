import 'package:flutter/material.dart';

import '../model/meal.dart';
import '../viewmodel/fetchmeal.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FetchMeal fetchMeal = FetchMeal();
  final TextEditingController searchController = TextEditingController();

  late Future<List<Meal>> mealsFuture;
  late Future<List<String>> categoriesFuture;

  String? selectedCategory;
  bool isRecommendations = true;
  String sectionTitle = 'Rekomendasi resep';

  @override
  void initState() {
    super.initState();

    mealsFuture = fetchMeal.searchMeals('chicken');
    categoriesFuture = fetchMeal.getCategories();
  }

  void _searchMeals() {
    final query = searchController.text.trim();

    FocusScope.of(context).unfocus();

    setState(() {
      selectedCategory = null;
      isRecommendations = query.isEmpty;

      if (query.isEmpty) {
        sectionTitle = 'Rekomendasi resep';
        mealsFuture = fetchMeal.searchMeals('chicken');
      } else {
        sectionTitle = 'Hasil pencarian';
        mealsFuture = fetchMeal.searchMeals(query);
      }
    });
  }

  void _loadRecommendations() {
    FocusScope.of(context).unfocus();

    searchController.clear();

    setState(() {
      selectedCategory = null;
      isRecommendations = true;
      sectionTitle = 'Rekomendasi resep';
      mealsFuture = fetchMeal.searchMeals('chicken');
    });
  }

  void _selectCategory(String category) {
    FocusScope.of(context).unfocus();

    searchController.clear();

    setState(() {
      selectedCategory = category;
      isRecommendations = false;
      sectionTitle = 'Kategori: $category';
      mealsFuture = fetchMeal.getMealsByCategory(category);
    });
  }

  void _retryMeals() {
    setState(() {
      if (selectedCategory != null) {
        mealsFuture = fetchMeal.getMealsByCategory(selectedCategory!);
      } else {
        final query = searchController.text.trim();

        mealsFuture = fetchMeal.searchMeals(query.isEmpty ? 'chicken' : query);
      }
    });
  }

  Future<void> _openRandomMeal() async {
    try {
      final meal = await fetchMeal.getRandomMeal();

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MealDetailPage(mealId: meal.id)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil resep acak.')),
      );
    }
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 54,
      child: FutureBuilder<List<String>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Kategori gagal dimuat.'));
          }

          final categories = snapshot.data ?? [];

          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('Rekomendasi'),
                  selected: isRecommendations,
                  onSelected: (_) => _loadRecommendations(),
                ),
              ),
              ...categories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (_) => _selectCategory(category),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    final categoryText = meal.category == '-' || meal.category.isEmpty
        ? selectedCategory ?? 'Pilihan'
        : meal.category;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MealDetailPage(mealId: meal.id)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  meal.imageUrl,
                  width: 115,
                  height: 110,
                  fit: BoxFit.cover,
                  webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 115,
                      height: 110,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.restaurant, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(
                          Icons.restaurant_menu,
                          size: 17,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            categoryText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Color(0xFF2E7D32),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Lihat detail resep',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2E7D32);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ResepKu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Resep acak',
            onPressed: _openRandomMeal,
            icon: const Icon(Icons.shuffle),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Masak Apa Hari Ini?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Temukan resep dan pelajari cara membuatnya.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchMeals(),
                  decoration: InputDecoration(
                    hintText: 'Cari nama makanan...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      tooltip: 'Hapus pencarian',
                      onPressed: () {
                        searchController.clear();
                        _searchMeals();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Kategori makanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildCategories(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                sectionTitle,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
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
                            'Resep gagal dimuat. Periksa koneksi '
                            'internet, lalu coba lagi.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _retryMeals,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final meals = snapshot.data ?? [];

                if (meals.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Resep tidak ditemukan. Coba kata kunci lain.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return _buildMealCard(meals[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
