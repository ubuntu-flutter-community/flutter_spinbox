import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';

import 'test_utils.dart';

typedef TestBuilder = Widget Function();
typedef TestChangeBuilder = Widget Function(ValueChanged<double> onChanged);

class TestIcons {
  TestIcons._();
  static IconData increment;
  static IconData decrement;
}

void testDefaults<S>(TestBuilder builder) {
  group('defaults', () {
    setUpUI((tester) async {
      final widget = builder();
      await tester.pumpWidget(widget);
    });

    testUI('structure', (tester) async {
      expect(find.byType(S), findsOneWidget);
      expect(find.editableText, findsOneWidget);
      expect(find.byIcon(TestIcons.increment), findsOneWidget);
      expect(find.byIcon(TestIcons.decrement), findsOneWidget);
    });

    testUI('value', (tester) async {
      expect(tester.state(find.byType(S)), hasValue(0));
    });

    testUI('text', (tester) async {
      expect(find.editableText, hasText('0'));
    });

    testUI('no focus', (tester) async {
      expect(find.editableText, hasNoFocus);
    });

    testUI('no selection', (tester) async {
      expect(find.editableText, hasNoSelection);
    });
  });
}

void testTap<S>(TestBuilder builder) {
  group('tap', () {
    setUpUI((tester) async {
      await tester.pumpWidget(builder());
    });

    group('text field', () {
      setUpUI((tester) async {
        await tester.tap(find.editableText);
        await tester.pumpAndSettle();
      });

      testUI('has focus', (tester) async {
        expect(find.editableText, hasFocus);
      });

      testUI('has selection', (tester) async {
        expect(find.editableText, hasSelection(0, 1));
      });
    });

    group('buttons', () {
      group('increment', () {
        setUpUI((tester) async {
          await tester.tap(find.byIcon(TestIcons.increment));
          await tester.pumpAndSettle();
        });

        testUI('no focus', (tester) async {
          expect(find.editableText, hasNoFocus);
        });

        testUI('no selection', (tester) async {
          expect(find.editableText, hasNoSelection);
        });

        testUI('was incremented', (tester) async {
          expect(tester.state(find.byType(S)), hasValue(2));
          expect(find.editableText, hasText('2'));
        });
      });

      group('decrement', () {
        setUpUI((tester) async {
          await tester.tap(find.byIcon(TestIcons.decrement));
          await tester.pumpAndSettle();
        });

        testUI('no focus', (tester) async {
          expect(find.editableText, hasNoFocus);
        });

        testUI('no selection', (tester) async {
          expect(find.editableText, hasNoSelection);
        });

        testUI('was decremented', (tester) async {
          expect(tester.state(find.byType(S)), hasValue(0));
          expect(find.editableText, hasText('0'));
        });
      });
    });
  });
}

void testInput<S>(TestBuilder builder) {
  group('input', () {
    setUpUI((tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));
    });

    testUI('arrows', (tester) async {
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

    testUI('text', (tester) async {
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

    testUI('submit', (tester) async {
      tester.testTextInput.updateEditingValue(TextEditingValue.empty);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(0));
      expect(find.editableText, hasText(''));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.idle();
      expect(find.editableText, hasNoFocus);
      expect(tester.state(find.byType(S)), hasValue(1));
      expect(find.editableText, hasText('1'));
    });

    testUI('unfocus', (tester) async {
      tester.testTextInput.updateEditingValue(TextEditingValue.empty);
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(0));

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
    setUpUI((tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));
    });

    testUI('min', (tester) async {
      await tester.pumpWidget(builder());
      expect(find.editableText, hasFocus);
      await tester.showKeyboard(find.byType(S));

      expect(find.editableText, hasSelection(0, 2));
      expect(find.editableText, hasText('20'));

      tester.testTextInput.enterText('9');
      await tester.idle();
      expect(tester.state(find.byType(S)), hasValue(9));
      expect(find.editableText, hasNoSelection);
      expect(find.editableText, hasText('9'));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.idle();
      expect(find.editableText, hasNoFocus);
      expect(tester.state(find.byType(S)), hasValue(20));
      expect(find.editableText, hasText('20'));
    });

    testUI('max', (tester) async {
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
  testUI('decimals', (tester) async {
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
    StreamController<double> controller;

    setUpUI((tester) async {
      controller = StreamController<double>();
      await tester.pumpWidget(builder(controller.add));
    });

    tearDownUI((tester) async {
      controller.close();
    });

    testUI('buttons', (tester) async {
      expectLater(controller.stream, emitsInOrder([0.0, 1.0]));
      await tester.tap(find.byIcon(TestIcons.decrement));
      await tester.tap(find.byIcon(TestIcons.increment));
    });

    testUI('input', (tester) async {
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
    StreamController<double> controller;

    setUpUI((tester) async {
      controller = StreamController<double>();
      await tester.pumpWidget(builder(controller.add));
    });

    tearDownUI((tester) async {
      controller.close();
    });

    testUI('increment', (tester) async {
      final center = tester.getCenter(find.byIcon(TestIcons.increment));
      final gesture = await tester.startGesture(center);
      await tester.pumpAndSettle(kLongPressTimeout);

      await expectLater(
          controller.stream, emitsInOrder([for (double i = 1; i <= 5; ++i) i]));
      gesture.up();
    });

    testUI('decrement', (tester) async {
      final center = tester.getCenter(find.byIcon(TestIcons.decrement));
      final gesture = await tester.startGesture(center);
      await tester.pumpAndSettle(kLongPressTimeout);

      await expectLater(controller.stream,
          emitsInOrder([for (double i = -1; i <= -5; --i) i]));
      gesture.up();
    });
  });
}
