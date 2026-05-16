import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/app/app.dart';

void main() {
  testWidgets('renders start screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ProviderScope(child: RecipeApp()));
    await tester.pumpAndSettle();

    expect(find.text('Hola!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });

  testWidgets('start login button opens auth login screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ProviderScope(child: RecipeApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Crea un compte'), findsOneWidget);
  });

  testWidgets('start sign up button opens auth sign up screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ProviderScope(child: RecipeApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Sign up'), findsOneWidget);
    expect(find.text('Crear compte'), findsOneWidget);
    expect(find.text('Nom'), findsOneWidget);
  });
}
