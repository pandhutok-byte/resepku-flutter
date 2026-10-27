class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String area;
  final String instructions;
  final String tags;
  final List<MealIngredient> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.area,
    required this.instructions,
    required this.tags,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final List<MealIngredient> ingredientList = [];

    // TheMealDB menyediakan hingga 20 pasangan bahan dan takaran.
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i']?.toString().trim() ?? '';

      final measure = json['strMeasure$i']?.toString().trim() ?? '';

      if (ingredient.isNotEmpty) {
        ingredientList.add(MealIngredient(name: ingredient, measure: measure));
      }
    }

    return Meal(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? 'Tanpa nama',
      imageUrl: json['strMealThumb']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '-',
      area: json['strArea']?.toString() ?? '-',
      instructions: json['strInstructions']?.toString() ?? '',
      tags: json['strTags']?.toString() ?? '',
      ingredients: ingredientList,
    );
  }
}

class MealIngredient {
  final String name;
  final String measure;

  MealIngredient({required this.name, required this.measure});
}
