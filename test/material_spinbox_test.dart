import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_spinbox.dart';

class TestApp extends MaterialApp {
  TestApp({Key? key, required Widget widget})
      : super(key: key, home: Scaffold(body: widget));
}

void main() {
  TestIcons.increment = Icons.add;
  TestIcons.decrement = Icons.remove;

  testDefaults<SpinBox>(() {
    return TestApp(widget: SpinBox());
  });

  testTap<SpinBox>(() {
    return TestApp(widget: SpinBox(value: 1));
  });

  testInput<SpinBox>(() {
    return TestApp(widget: SpinBox(value: 1, autofocus: true));
  });

  testRange<SpinBox>(() {
    return TestApp(
        widget: SpinBox(min: 10, max: 30, value: 20, autofocus: true));
  });

  testDecimals<SpinBox>(() {
    return TestApp(
        widget:
            SpinBox(min: -1, max: 1, value: 0.5, decimals: 2, autofocus: true));
  });

  testCallbacks<SpinBox>((onChanged) {
    return TestApp(widget: SpinBox(value: 1, onChanged: onChanged));
  });

  testLongPress<SpinBox>((onChanged) {
    return TestApp(widget: SpinBox(min: -5, max: 5, onChanged: onChanged));
  });

  group('icon color', () {
    final iconColor = MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) return Colors.yellow;
      if (states.contains(MaterialState.error)) return Colors.red;
      if (states.contains(MaterialState.focused)) return Colors.blue;
      return Colors.green;
    });

    testWidgets('normal', (tester) async {
      await tester.pumpWidget(TestApp(widget: SpinBox(iconColor: iconColor)));

      final increment = find.widgetWithIcon(IconButton, TestIcons.increment);
      expect(increment, findsOneWidget);
      expect(tester.widget<IconButton>(increment).onPressed, isNotNull);
      expect(tester.widget<IconButton>(increment).color, equals(Colors.green));

      final decrement = find.widgetWithIcon(IconButton, TestIcons.decrement);
      expect(decrement, findsOneWidget);
      expect(tester.widget<IconButton>(decrement).onPressed, isNull);
      expect(tester.widget<IconButton>(decrement).color, equals(Colors.yellow));
    });

    testWidgets('error', (tester) async {
      await tester.pumpWidget(
        TestApp(
          widget: SpinBox(
              iconColor: iconColor, validator: (_) => 'error', value: 100),
        ),
      );

      final increment = find.widgetWithIcon(IconButton, TestIcons.increment);
      expect(increment, findsOneWidget);
      expect(tester.widget<IconButton>(increment).onPressed, isNull);
      expect(tester.widget<IconButton>(increment).color, equals(Colors.yellow));

      final decrement = find.widgetWithIcon(IconButton, TestIcons.decrement);
      expect(decrement, findsOneWidget);
      expect(tester.widget<IconButton>(decrement).onPressed, isNotNull);
      expect(tester.widget<IconButton>(decrement).color, equals(Colors.red));
    });

    testWidgets('focused', (tester) async {
      await tester.pumpWidget(
        TestApp(
          widget: SpinBox(
            autofocus: true,
            iconColor: iconColor,
            value: 50,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final increment = find.widgetWithIcon(IconButton, TestIcons.increment);
      expect(increment, findsOneWidget);
      expect(tester.widget<IconButton>(increment).onPressed, isNotNull);
      expect(tester.widget<IconButton>(increment).color, equals(Colors.blue));

      final decrement = find.widgetWithIcon(IconButton, TestIcons.decrement);
      expect(decrement, findsOneWidget);
      expect(tester.widget<IconButton>(decrement).onPressed, isNotNull);
      expect(tester.widget<IconButton>(decrement).color, equals(Colors.blue));
    });

    testWidgets('theme', (tester) async {
      await tester.pumpWidget(
        TestApp(
          widget: SpinBoxTheme(
            data: SpinBoxThemeData(
              iconColor: iconColor,
            ),
            child: SpinBox(),
          ),
        ),
      );

      final increment = find.widgetWithIcon(IconButton, TestIcons.increment);
      expect(increment, findsOneWidget);
      expect(tester.widget<IconButton>(increment).onPressed, isNotNull);
      expect(tester.widget<IconButton>(increment).color, equals(Colors.green));

      final decrement = find.widgetWithIcon(IconButton, TestIcons.decrement);
      expect(decrement, findsOneWidget);
      expect(tester.widget<IconButton>(decrement).onPressed, isNull);
      expect(tester.widget<IconButton>(decrement).color, equals(Colors.yellow));
    });

    testWidgets('override', (tester) async {
      await tester.pumpWidget(
        TestApp(
          widget: SpinBoxTheme(
            data: SpinBoxThemeData(
              iconColor: MaterialStateProperty.all(Colors.black),
            ),
            child: SpinBox(iconColor: iconColor),
          ),
        ),
      );

      final increment = find.widgetWithIcon(IconButton, TestIcons.increment);
      expect(increment, findsOneWidget);
      expect(tester.widget<IconButton>(increment).onPressed, isNotNull);
      expect(tester.widget<IconButton>(increment).color, equals(Colors.green));

      final decrement = find.widgetWithIcon(IconButton, TestIcons.decrement);
      expect(decrement, findsOneWidget);
      expect(tester.widget<IconButton>(decrement).onPressed, isNull);
      expect(tester.widget<IconButton>(decrement).color, equals(Colors.yellow));
    });
  });

  group('input decoration', () {
    testWidgets('custom', (tester) async {
      await tester.pumpWidget(TestApp(
          widget: SpinBox(
        decoration: const InputDecoration(labelText: 'custom'),
      )));

      final input = find.byType(TextField);
      expect(input, findsOneWidget);
      final decoration = tester.widget<TextField>(input).decoration;
      expect(decoration, isNotNull);
      expect(decoration!.labelText, equals('custom'));
    });

    testWidgets('theme', (tester) async {
      await tester.pumpWidget(TestApp(
          widget: SpinBoxTheme(
        data: const SpinBoxThemeData(
          decoration: InputDecoration(labelText: 'theme'),
        ),
        child: SpinBox(),
      )));

      final input = find.byType(TextField);
      expect(input, findsOneWidget);
      final decoration = tester.widget<TextField>(input).decoration;
      expect(decoration, isNotNull);
      expect(decoration!.labelText, equals('theme'));
    });

    testWidgets('override', (tester) async {
      await tester.pumpWidget(TestApp(
        widget: SpinBoxTheme(
          data: const SpinBoxThemeData(
            decoration: InputDecoration(labelText: 'theme'),
          ),
          child: SpinBox(
            decoration: const InputDecoration(labelText: 'custom'),
          ),
        ),
      ));

      final input = find.byType(TextField);
      expect(input, findsOneWidget);
      final decoration = tester.widget<TextField>(input).decoration;
      expect(decoration, isNotNull);
      expect(decoration!.labelText, equals('custom'));
    });
  });
}
