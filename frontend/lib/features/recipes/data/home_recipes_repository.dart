import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import '../presentation/widgets/home_recipe_models.dart';

class HomeRecipesRepository {
  const HomeRecipesRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<HomeRecipe>> fetchHomeRecipes({required String feed}) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        Endpoints.home,
        queryParameters: {'feed': feed},
      );
      final recipes = response.data?['recipes'];

      if (recipes is! List) {
        return const [];
      }

      return recipes
          .whereType<Map<String, dynamic>>()
          .map(HomeRecipe.fromJson)
          .toList();
    } on DioException catch (error) {
      throw HomeRecipesException.fromDio(error);
    }
  }

  Future<List<HomeRecipe>> fetchSavedRecipes() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        Endpoints.userSavedRecipes,
      );
      final savedRecipes = response.data?['user_saved_recipes'];

      if (savedRecipes is! List) {
        return const [];
      }

      return savedRecipes
          .whereType<Map<String, dynamic>>()
          .map(HomeRecipe.fromSavedRecipeJson)
          .toList();
    } on DioException catch (error) {
      throw HomeRecipesException.fromDio(error);
    }
  }

  Future<int> likeRecipe(String recipeId) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        Endpoints.userRecipeLikes,
        data: {
          'user_recipe_like': {'recipe_id': recipeId},
        },
      );

      return _readNestedId(response.data, 'user_recipe_like');
    } on DioException catch (error) {
      throw HomeRecipesException.fromDio(error);
    }
  }

  Future<void> unlikeRecipe(int likeId) async {
    try {
      await _apiClient.dio.delete<void>('${Endpoints.userRecipeLikes}/$likeId');
    } on DioException catch (error) {
      throw HomeRecipesException.fromDio(error);
    }
  }

  Future<int> saveRecipe(String recipeId) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        Endpoints.userSavedRecipes,
        data: {
          'user_saved_recipe': {'recipe_id': recipeId},
        },
      );

      return _readNestedId(response.data, 'user_saved_recipe');
    } on DioException catch (error) {
      throw HomeRecipesException.fromDio(error);
    }
  }

  Future<void> unsaveRecipe(int savedRecipeId) async {
    try {
      await _apiClient.dio.delete<void>(
        '${Endpoints.userSavedRecipes}/$savedRecipeId',
      );
    } on DioException catch (error) {
      throw HomeRecipesException.fromDio(error);
    }
  }

  int _readNestedId(Map<String, dynamic>? data, String key) {
    final payload = data?[key];
    if (payload is Map<String, dynamic>) {
      final id = payload['id'];
      if (id is int) {
        return id;
      }

      final parsed = int.tryParse(id?.toString() ?? '');
      if (parsed != null) {
        return parsed;
      }
    }

    throw const HomeRecipesException('No s ha pogut actualitzar la recepta.');
  }
}

class HomeRecipesException implements Exception {
  const HomeRecipesException(this.message);

  final String message;

  factory HomeRecipesException.fromDio(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final payload = data['error'];
      if (payload is Map<String, dynamic>) {
        return HomeRecipesException(
          payload['message'] as String? ??
              'No s han pogut carregar les receptes.',
        );
      }
    }

    return const HomeRecipesException(
      'No s han pogut carregar les receptes. Torna-ho a provar.',
    );
  }

  @override
  String toString() => message;
}
