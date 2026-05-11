import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/app/app.dart';

void main() {
  testWidgets('renders login placeholder', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: RecipeApp()));
    await tester.pumpAndSettle();

    expect(find.text('Recipe App'), findsOneWidget);
    expect(find.text('Entrar amb flow temporal'), findsOneWidget);
  });
}
