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
    return TestApp(widget: SpinBox(value: 1, autofocus: true, pageStep: 10));
  });

  testInput<SpinBox>(() {
    return TestApp(
      widget: SpinBox(
        value: 1,
        autofocus: true,
        focusNode: FocusNode(),
        pageStep: 10,
      ),
    );
  });

  testRange<SpinBox>(() {
    return TestApp(
      widget: SpinBox(min: 10, max: 30, value: 20, autofocus: true),
    );
  });

  testRange<SpinBox>(() {
    return TestApp(
      widget: SpinBox(
        min: 10,
        max: 30,
        value: 20,
        autofocus: true,
        focusNode: FocusNode(),
      ),
    );
  });

  testDecimals<SpinBox>(() {
    return TestApp(
      widget:
          SpinBox(min: -1, max: 1, value: 0.5, decimals: 2, autofocus: true),
    );
  });

  testDecimals<SpinBox>(() {
    return TestApp(
      widget: SpinBox(
        min: -1,
        max: 1,
        value: 0.5,
        decimals: 2,
        autofocus: true,
        focusNode: FocusNode(),
      ),
    );
  });

  testCallbacks<SpinBox>((onChanged) {
    return TestApp(widget: SpinBox(value: 1, onChanged: onChanged));
  });

  testLongPress<SpinBox>((onChanged) {
    return TestApp(widget: SpinBox(min: -5, max: 5, onChanged: onChanged));
  });

  group('icon color', () {
    final iconColor = WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return Colors.yellow;
      if (states.contains(WidgetState.error)) return Colors.red;
      if (states.contains(WidgetState.focused)) return Colors.blue;
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

    testWidgets('focused custom focus', (tester) async {
      await tester.pumpWidget(
        TestApp(
          widget: SpinBox(
            autofocus: true,
            iconColor: iconColor,
            focusNode: FocusNode(),
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
              iconColor: WidgetStateProperty.all(Colors.black),
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

    testWidgets('prefix', (tester) async {
      await tester.pumpWidget(
        TestApp(
          widget: SpinBox(
            spacing: 25,
            decoration: const InputDecoration(prefix: Text('prefix')),
          ),
        ),
      );

      final decrement = find.byIcon(TestIcons.decrement);
      expect(decrement, findsOneWidget);

      final prefix = find.text('prefix');
      expect(prefix, findsOneWidget);

      expect(
        tester.getRect(prefix).left,
        greaterThanOrEqualTo(tester.getRect(decrement).right + 25),
      );
    });

    testWidgets('suffix', (tester) async {
      await tester.pumpWidget(
        TestApp(
          widget: SpinBox(
            spacing: 25,
            decoration: const InputDecoration(suffix: Text('suffix')),
          ),
        ),
      );

      final increment = find.byIcon(TestIcons.increment);
      expect(increment, findsOneWidget);

      final suffix = find.text('suffix');
      expect(suffix, findsOneWidget);

      expect(
        tester.getRect(suffix).right,
        lessThanOrEqualTo(tester.getRect(increment).left - 25),
      );
    });
  });
}
