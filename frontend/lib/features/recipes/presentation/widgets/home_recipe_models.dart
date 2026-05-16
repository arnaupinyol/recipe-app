import '../../../../app/assets/app_assets.dart';
import '../../../../core/config/env.dart';

const _fallbackRecipeImageAsset = AppAssets.appIconLarge;
const _fallbackRowImageAsset = AppAssets.appIconSmall;

class HomeRecipe {
  const HomeRecipe({
    required this.id,
    required this.title,
    required this.authorAvatarAsset,
    required this.imageAsset,
    this.imageUrl,
    required this.difficulty,
    required this.duration,
    required this.servings,
    required this.filters,
    required this.ingredients,
    required this.utensils,
    required this.steps,
    this.isLiked = true,
    this.isBookmarked = false,
  });

  final String id;
  final String title;
  final String authorAvatarAsset;
  final String imageAsset;
  final String? imageUrl;
  final int difficulty;
  final String duration;
  final String servings;
  final List<String> filters;
  final List<HomeRecipeIngredient> ingredients;
  final List<HomeRecipeUtensil> utensils;
  final List<HomeRecipeStep> steps;
  final bool isLiked;
  final bool isBookmarked;

  factory HomeRecipe.fromJson(Map<String, dynamic> json) {
    final categories = _readList(
      json['categories'],
    ).map((item) => _readString(item['name'])).whereType<String>().toList();
    final imageUrls = _readObjectList(json['image_urls'])
        .map((item) => _absoluteBackendUrl(item?.toString()))
        .whereType<String>()
        .toList();
    final primaryImageUrl =
        _firstOrNull(imageUrls) ??
        _absoluteBackendUrl(_readString(json['image_url']));

    return HomeRecipe(
      id: _readString(json['id']) ?? '',
      title: _readString(json['title']) ?? 'Recepta',
      authorAvatarAsset: AppAssets.userIcon,
      imageAsset: _fallbackRecipeImageAsset,
      imageUrl: primaryImageUrl,
      difficulty: _readInt(json['difficulty'])?.clamp(0, 5) ?? 0,
      duration: _formatDuration(_readInt(json['preparation_time_minutes'])),
      servings: _formatServings(_readInt(json['servings'])),
      filters: categories,
      ingredients: _readList(
        json['ingredients'],
      ).map(HomeRecipeIngredient.fromJson).toList(),
      utensils: _readList(
        json['utensils'],
      ).map(HomeRecipeUtensil.fromJson).toList(),
      steps: _readList(json['steps']).map(HomeRecipeStep.fromJson).toList(),
      isLiked: json['liked_by_current_user'] == true,
      isBookmarked: json['saved_by_current_user'] == true,
    );
  }
}

class HomeRecipeIngredient {
  const HomeRecipeIngredient({
    required this.name,
    required this.amount,
    required this.note,
    required this.imageAsset,
    this.imageUrl,
  });

  final String name;
  final String amount;
  final String note;
  final String imageAsset;
  final String? imageUrl;

  factory HomeRecipeIngredient.fromJson(Map<String, dynamic> json) {
    return HomeRecipeIngredient(
      name: _readString(json['name']) ?? 'Ingredient',
      amount: _formatIngredientAmount(
        quantity: json['quantity'],
        unitType: _readString(json['unit_type']),
      ),
      note: _readString(json['notes']) ?? '',
      imageAsset: _fallbackRowImageAsset,
      imageUrl: _absoluteBackendUrl(_readString(json['image_url'])),
    );
  }
}

class HomeRecipeUtensil {
  const HomeRecipeUtensil({
    required this.name,
    required this.imageAsset,
    this.imageUrl,
  });

  final String name;
  final String imageAsset;
  final String? imageUrl;

  factory HomeRecipeUtensil.fromJson(Map<String, dynamic> json) {
    return HomeRecipeUtensil(
      name: _readString(json['name']) ?? 'Estri',
      imageAsset: _fallbackRowImageAsset,
      imageUrl: _absoluteBackendUrl(_readString(json['image_url'])),
    );
  }
}

class HomeRecipeStep {
  const HomeRecipeStep({
    required this.orderNumber,
    required this.title,
    required this.description,
  });

  final int orderNumber;
  final String title;
  final String description;

  factory HomeRecipeStep.fromJson(Map<String, dynamic> json) {
    final order = _readInt(json['order_number']) ?? 1;

    return HomeRecipeStep(
      orderNumber: order,
      title: _readString(json['title']) ?? '',
      description: _readString(json['description']) ?? '',
    );
  }
}

List<Map<String, dynamic>> _readList(Object? value) {
  if (value is! List) {
    return const [];
  }

  return value.whereType<Map<String, dynamic>>().toList();
}

List<Object?> _readObjectList(Object? value) {
  if (value is! List) {
    return const [];
  }

  return value;
}

T? _firstOrNull<T>(List<T> values) {
  if (values.isEmpty) {
    return null;
  }

  return values.first;
}

String? _readString(Object? value) {
  if (value == null) {
    return null;
  }

  return value.toString();
}

int? _readInt(Object? value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '');
}

double? _readDouble(Object? value) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '');
}

String _formatDuration(int? minutes) {
  if (minutes == null || minutes <= 0) {
    return '-';
  }

  if (minutes < 60) {
    return '${minutes}min';
  }

  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  if (remainingMinutes == 0) {
    return '${hours}h';
  }

  return '${hours}h ${remainingMinutes}min';
}

String _formatServings(int? servings) {
  if (servings == null || servings <= 0) {
    return '-';
  }

  return '${servings}p.';
}

String _formatIngredientAmount({required Object? quantity, String? unitType}) {
  final amount = _formatQuantity(quantity);
  final unit = switch (unitType) {
    'grams' => 'grams',
    'units' => 'unitats',
    'ml' => 'ml',
    _ => '',
  };

  return [amount, unit].where((part) => part.isNotEmpty).join(' ');
}

String _formatQuantity(Object? quantity) {
  final value = _readDouble(quantity);
  if (value == null) {
    return '';
  }

  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toString();
}

String? _absoluteBackendUrl(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  final uri = Uri.tryParse(value);
  if (uri == null) {
    return null;
  }

  if (uri.hasScheme) {
    return value;
  }

  final apiBaseUri = Uri.parse(Env.apiBaseUrl);
  return '${apiBaseUri.scheme}://${apiBaseUri.authority}$value';
}
