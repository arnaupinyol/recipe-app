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
