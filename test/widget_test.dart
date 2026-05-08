import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:brutalist_bmi_calculator/main.dart';
import 'package:brutalist_bmi_calculator/screens/calculator_screen.dart';

void main() {
  testWidgets('app starts on the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BrutalBMICalculator());

    expect(find.text('BMI\nCALCULATOR'), findsOneWidget);
    expect(find.text('STAY FIT OR DIE TRYING'), findsOneWidget);
    expect(find.byType(CalculatorScreen), findsNothing);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('app navigates to calculator after splash delay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BrutalBMICalculator());

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(CalculatorScreen), findsOneWidget);
    expect(find.text('BMI CALCULATOR'), findsOneWidget);
    expect(find.text('NORMAL'), findsAtLeastNWidgets(1));
    expect(find.text('24.2'), findsAtLeastNWidgets(1));
    expect(find.text('CLASSIFICATION REFERENCE'), findsOneWidget);
  });

  testWidgets('calculator screen can change language and weight unit', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BrutalBMICalculator());

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('SELECT LANGUAGE'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Français').last);
    await tester.pumpAndSettle();

    expect(find.text('CALCULATEUR IMC'), findsOneWidget);

    await tester.tap(find.text('KG').last);
    await tester.pumpAndSettle();

    expect(find.text('UNITÉ DE POIDS'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('LB').last);
    await tester.pumpAndSettle();

    expect(find.text('LB'), findsWidgets);
  });
}
