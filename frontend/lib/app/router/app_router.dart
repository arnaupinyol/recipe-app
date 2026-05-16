import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/start_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/recipes/presentation/screens/recipe_detail_screen.dart';
import '../../features/recipes/presentation/screens/recipes_screen.dart';
import '../../features/recipes/presentation/screens/saved_recipes_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.start,
    routes: [
      GoRoute(
        path: RoutePaths.start,
        name: RouteNames.start,
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.recipes,
        name: RouteNames.recipes,
        builder: (context, state) => const RecipesScreen(),
      ),
      GoRoute(
        path: RoutePaths.recipeDetail,
        name: RouteNames.recipeDetail,
        builder: (context, state) {
          final recipeId = state.pathParameters['id'] ?? 'unknown';
          return RecipeDetailScreen(recipeId: recipeId);
        },
      ),
      GoRoute(
        path: RoutePaths.savedRecipes,
        name: RouteNames.savedRecipes,
        builder: (context, state) => const SavedRecipesScreen(),
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
