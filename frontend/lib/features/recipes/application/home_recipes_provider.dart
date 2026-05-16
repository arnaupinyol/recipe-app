import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../auth/application/auth_controller.dart';
import '../data/home_recipes_repository.dart';
import '../presentation/widgets/home_recipe_models.dart';

enum HomeFeed {
  forYou('for_you'),
  following('following');

  const HomeFeed(this.apiValue);

  final String apiValue;
}

final homeRecipesRepositoryProvider = Provider<HomeRecipesRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);

  return HomeRecipesRepository(ApiClient(readToken: storage.readToken));
});

final homeRecipesProvider = FutureProvider.family<List<HomeRecipe>, HomeFeed>((
  ref,
  feed,
) {
  return ref
      .watch(homeRecipesRepositoryProvider)
      .fetchHomeRecipes(feed: feed.apiValue);
});
