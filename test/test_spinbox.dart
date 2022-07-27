import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

typedef TestBuilder = Widget Function();
typedef TestChangeBuilder = Widget Function(ValueChanged<double> onChanged);

class TestIcons {
  TestIcons._();
  static late IconData increment;
  static late IconData decrement;
}

void testDefaults<S>(TestBuilder builder) {
  group('defaults', () {
    testWidgets('structure', (tester) async {
      final widget = builder();
      await tester.pumpWidget(widget);

      expect(find.byType(S), findsOneWidget);
      expect(find.editableText, findsOneWidget);
      expect(find.byIcon(TestIcons.increment), findsOneWidget);
      expect(find.byIcon(TestIcons.decrement), findsOneWidget);
    });

    testWidgets('value', (tester) async {
      final widget = builder();
      await tester.pumpWidget(widget);

      expect(tester.state(find.byType(S)), hasValue(0));
    });

    testWidgets('text', (tester) async {
      final widget = builder();
      await tester.pumpWidget(widget);

      expect(find.editableText, hasText('0'));
    });

    testWidgets('no focus', (tester) async {
      final widget = builder();
      await tester.pumpWidget(widget);

      expect(find.editableText, hasNoFocus);
    });

    testWidgets('no selection', (tester) async {
      final widget = builder();
      await tester.pumpWidget(widget);

      expect(find.editableText, hasNoSelection);
    });
  });
}

void testTap<S>(TestBuilder builder) {
  group('tap', () {
    group('text field', () {
      testWidgets('has focus', (tester) async {
        await tester.pumpWidget(builder());
        await tester.tap(find.editableText);
        await tester.pumpAndSettle();

        expect(find.editableText, hasFocus);
      });

      testWidgets('has selection', (tester) async {
        await tester.pumpWidget(builder());
        await tester.tap(find.editableText);
        await tester.pumpAndSettle();

        expect(find.editableText, hasSelection(0, 1));
      });
    });

    group('buttons', () {
      group('increment', () {
        testWidgets('no focus', (tester) async {
          await tester.pumpWidget(builder());
          await tester.tap(find.byIcon(TestIcons.increment));
          await tester.pumpAndSettle();

          expect(find.editableText, hasNoFocus);
        });

        testWidgets('no selection', (tester) async {
          await tester.pumpWidget(builder());
          await tester.tap(find.byIcon(TestIcons.increment));
          await tester.pumpAndSettle();

          expect(find.editableText, hasNoSelection);
        });

        testWidgets('was incremented', (tester) async {
          await tester.pumpWidget(builder());
          await tester.tap(find.byIcon(TestIcons.increment));
          await tester.pumpAndSettle();

          expect(tester.state(find.byType(S)), hasValue(2));
          expect(find.editableText, hasText('2'));
        });
      });

      group('decrement', () {
        testWidgets('no focus', (tester) async {
          await tester.pumpWidget(builder());
          await tester.tap(find.byIcon(TestIcons.decrement));
          await tester.pumpAndSettle();

          expect(find.editableText, hasNoFocus);
        });

        testWidgets('no selection', (tester) async {
          await tester.pumpWidget(builder());
          await tester.tap(find.byIcon(TestIcons.decrement));
          await tester.pumpAndSettle();

          expect(find.editableText, hasNoSelection);
        });

        testWidgets('was decremented', (tester) async {
          await tester.pumpWidget(builder());
          await tester.tap(find.byIcon(TestIcons.decrement));
          await tester.pumpAndSettle();

          expect(tester.state(find.byType(S)), hasValue(0));
          expect(find.editableText, hasText('0'));
        });
      });
    });
  });
}

void testInput<S>(TestBuilder builder) {
  group('input', () {
    testWidgets('arrows', (tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(0));
      expect(find.editableText, hasText('0'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(1));
      expect(find.editableText, hasText('1'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(0));
      expect(find.editableText, hasText('0'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(0));
      expect(find.editableText, hasText('0'));
    });

    testWidgets('page step', (tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));

      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(0));
      expect(find.editableText, hasText('0'));

      await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(10));
      expect(find.editableText, hasText('10'));

      await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(20));
      expect(find.editableText, hasText('20'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(19));
      expect(find.editableText, hasText('19'));

      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(9));
      expect(find.editableText, hasText('9'));

      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(0));
      expect(find.editableText, hasText('0'));
    });

    testWidgets('text', (tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));

      expect(find.editableText, hasSelection(0, 1));
      expect(find.editableText, hasText('1'));

      tester.testTextInput.enterText('2');
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(2));
      expect(find.editableText, hasNoSelection);
      expect(find.editableText, hasText('2'));

      tester.testTextInput.enterText('a');
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(2));
      expect(find.editableText, hasNoSelection);
      expect(find.editableText, hasText('2'));

      tester.testTextInput.enterText('21');
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(21));
      expect(find.editableText, hasNoSelection);
      expect(find.editableText, hasText('21'));

      tester.testTextInput.enterText('321');
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(21));
      expect(find.editableText, hasNoSelection);
      expect(find.editableText, hasText('21'));
    });

    testWidgets('submit', (tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));

      tester.testTextInput.updateEditingValue(TextEditingValue.empty);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(1));
      expect(find.editableText, hasText(''));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.idle();
      expect(find.editableText, hasNoFocus);
      expect(tester.state(find.byType(S)), hasValue(1));
      expect(find.editableText, hasText('1'));
    });

    testWidgets('unfocus', (tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));

      tester.testTextInput.updateEditingValue(TextEditingValue.empty);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(1));
      expect(find.editableText, hasText(''));

      find.editableText.focusNode.unfocus();
      await tester.idle();
      expect(find.editableText, hasNoFocus);
      expect(tester.state(find.byType(S)), hasValue(1));
      expect(find.editableText, hasText('1'));
    });
  });
}

void testRange<S>(TestBuilder builder) {
  group('range', () {
    testWidgets('min', (tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));

      expect(find.editableText, hasSelection(0, 2));
      expect(find.editableText, hasText('20'));

      tester.testTextInput.enterText('9');
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(20));
      expect(find.editableText, hasNoSelection);
      expect(find.editableText, hasText('9'));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.idle();
      expect(find.editableText, hasNoFocus);
      expect(tester.state(find.byType(S)), hasValue(10));
      expect(find.editableText, hasText('10'));
    });

    testWidgets('max', (tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));

      expect(find.editableText, hasSelection(0, 2));
      expect(find.editableText, hasText('20'));

      tester.testTextInput.enterText('31');
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(20));
      expect(find.editableText, hasSelection(0, 2));
      expect(find.editableText, hasText('20'));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.idle();
      expect(find.editableText, hasNoFocus);
      expect(tester.state(find.byType(S)), hasValue(20));
      expect(find.editableText, hasText('20'));
    });
  });
}

void testDecimals<S>(TestBuilder builder) {
  testWidgets('decimals', (tester) async {
    await tester.pumpWidget(builder());
    expect(find.editableText, hasFocus);
    await tester.showKeyboard(find.byType(S));

    expect(tester.state(find.byType(S)), hasValue(0.5));
    expect(find.editableText, hasSelection(0, 4));
    expect(find.editableText, hasText('0.50'));

    tester.testTextInput.enterText('0.50123');
    await tester.idle();
    expect(tester.state(find.byType(S)), hasValue(0.5));
    expect(find.editableText, hasText('0.50'));
  });
}

void testCallbacks<S>(TestChangeBuilder builder) {
  group('callbacks', () {
    late StreamController<double> controller;

    setUp(() async {
      controller = StreamController<double>();
    });

    tearDown(() async {
      controller.close();
    });

    testWidgets('buttons', (tester) async {
      await tester.pumpWidget(builder(controller.add));

      expectLater(controller.stream, emitsInOrder([0.0, 1.0]));
      await tester.tap(find.byIcon(TestIcons.decrement));
      await tester.tap(find.byIcon(TestIcons.increment));
    });

    testWidgets('input', (tester) async {
      await tester.pumpWidget(builder(controller.add));

      await tester.showKeyboard(find.byType(S));
      expect(find.editableText, hasFocus);
      expect(find.editableText, hasSelection(0, 1));

      expectLater(controller.stream, emitsInOrder([2.0, 22.0]));

      tester.testTextInput.enterText('2');
      await tester.idle();

      tester.testTextInput.enterText('22');
      await tester.idle();
    });
  });
}

void testLongPress<S>(TestChangeBuilder builder) {
  group('long press', () {
    late StreamController<double> controller;

    setUp(() async {
      controller = StreamController<double>();
    });

    tearDown(() async {
      controller.close();
    });

    testWidgets('increment', (tester) async {
      await tester.pumpWidget(builder(controller.add));

      final center = tester.getCenter(find.byIcon(TestIcons.increment));
      final gesture = await tester.startGesture(center);
      await tester.pumpAndSettle(kLongPressTimeout);

      await expectLater(
          controller.stream, emitsInOrder([for (double i = 1; i <= 5; ++i) i]));
      gesture.up();
    });

    testWidgets('decrement', (tester) async {
      await tester.pumpWidget(builder(controller.add));

      final center = tester.getCenter(find.byIcon(TestIcons.decrement));
      final gesture = await tester.startGesture(center);
      await tester.pumpAndSettle(kLongPressTimeout);

      await expectLater(controller.stream,
          emitsInOrder([for (double i = -1; i <= -5; --i) i]));
      gesture.up();
    });
  });
}
