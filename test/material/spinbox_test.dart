import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ui/flutter_test_ui.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import 'test_utils.dart';

void main() {
  group('defaults', () {
    setUpUI((tester) async {
      await tester.pumpWidget(TestApp(widget: SpinBox()));
    });

    testUI('structure', (tester) async {
      expect(find.spinBox, findsOneWidget);
      expect(find.textField, findsOneWidget);
      expect(find.increment, findsOneWidget);
      expect(find.decrement, findsOneWidget);
    });

    testUI('value', (tester) async {
      expect(tester.state(find.spinBox), hasValue(0));
    });

    testUI('text', (tester) async {
      expect(find.textField, hasText('0'));
    });

    testUI('no focus', (tester) async {
      expect(find.textField, hasNoFocus);
    });

    testUI('no selection', (tester) async {
      expect(find.textField, hasNoSelection);
    });
  });

  group('tap', () {
    setUpUI((tester) async {
      await tester.pumpWidget(TestApp(widget: SpinBox(value: 1)));
    });

    group('text field', () {
      setUpUI((tester) async {
        await tester.tap(find.textField);
        await tester.pumpAndSettle();
      });

      testUI('has focus', (tester) async {
        expect(find.textField, hasFocus);
      });

      testUI('has selection', (tester) async {
        expect(find.textField, hasSelection(0, 1));
      });
    });

    group('buttons', () {
      group('increment', () {
        setUpUI((tester) async {
          await tester.tap(find.increment);
          await tester.pumpAndSettle();
        });

        testUI('no focus', (tester) async {
          expect(find.textField, hasNoFocus);
        });

        testUI('no selection', (tester) async {
          expect(find.textField, hasNoSelection);
        });

        testUI('was incremented', (tester) async {
          expect(tester.state(find.spinBox), hasValue(2));
          expect(find.textField, hasText('2'));
        });
      });

      group('decrement', () {
        setUpUI((tester) async {
          await tester.tap(find.decrement);
          await tester.pumpAndSettle();
        });

        testUI('no focus', (tester) async {
          expect(find.textField, hasNoFocus);
        });

        testUI('no selection', (tester) async {
          expect(find.textField, hasNoSelection);
        });

        testUI('was decremented', (tester) async {
          expect(tester.state(find.spinBox), hasValue(0));
          expect(find.textField, hasText('0'));
        });
      });
    });
  });

  group('input', () {
    setUpUI((tester) async {
      final spinBox = SpinBox(value: 1, autofocus: true);
      await tester.pumpWidget(TestApp(widget: spinBox));
      expect(find.textField, hasFocus);
      await tester.showKeyboard(find.spinBox);
    });

    testUI('arrows', (tester) async {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(0));
      expect(find.textField, hasText('0'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(1));
      expect(find.textField, hasText('1'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(0));
      expect(find.textField, hasText('0'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(0));
      expect(find.textField, hasText('0'));
    });

    testUI('text', (tester) async {
      expect(find.textField, hasSelection(0, 1));
      expect(find.textField, hasText('1'));

      tester.testTextInput.enterText('2');
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(2));
      expect(find.textField, hasNoSelection);
      expect(find.textField, hasText('2'));

      tester.testTextInput.enterText('a');
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(2));
      expect(find.textField, hasNoSelection);
      expect(find.textField, hasText('2'));

      tester.testTextInput.enterText('21');
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(21));
      expect(find.textField, hasNoSelection);
      expect(find.textField, hasText('21'));

      tester.testTextInput.enterText('321');
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(21));
      expect(find.textField, hasNoSelection);
      expect(find.textField, hasText('21'));
    });

    testUI('submit', (tester) async {
      await tester.showKeyboard(find.textField);
      tester.testTextInput.updateEditingValue(TextEditingValue.empty);
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(0));

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.idle();
      expect(find.textField, hasNoFocus);
      expect(tester.state(find.spinBox), hasValue(1));
    });

    testUI('unfocus', (tester) async {
      await tester.showKeyboard(find.textField);
      tester.testTextInput.updateEditingValue(TextEditingValue.empty);
      await tester.idle();
      expect(tester.state(find.spinBox), hasValue(0));

      find.textField.focusNode.unfocus();
      await tester.idle();
      expect(find.textField, hasNoFocus);
      expect(tester.state(find.spinBox), hasValue(1));
    });
  });

  testUI('decimals', (tester) async {
    final spinBox = SpinBox(min: -1, max: 1, value: 0.5, decimals: 2);
    await tester.pumpWidget(TestApp(widget: spinBox));

    expect(tester.state(find.spinBox), hasValue(0.5));
    expect(find.textField, hasText('0.50'));
  });

  group('callbacks', () {
    StreamController<double> values;

    setUpUI((tester) async {
      values = StreamController<double>();
      final spinBox = SpinBox(value: 1, onChanged: (v) => values.add(v));
      await tester.pumpWidget(TestApp(widget: spinBox));
    });

    tearDownUI((tester) async {
      values.close();
    });

    testUI('buttons', (tester) async {
      expectLater(values.stream, emitsInOrder([0.0, 1.0]));
      await tester.tap(find.decrement);
      await tester.tap(find.increment);
    });

    testUI('input', (tester) async {
      await tester.showKeyboard(find.spinBox);
      expect(find.textField, hasFocus);
      expect(find.textField, hasSelection(0, 1));

      expectLater(values.stream, emitsInOrder([2.0, 22.0]));

      tester.testTextInput.enterText('2');
      await tester.idle();

      tester.testTextInput.enterText('22');
      await tester.idle();
    });
  });

  group('long press', () {
    StreamController<double> values;

    setUpUI((tester) async {
      values = StreamController<double>();
      final spinBox = SpinBox(min: -5, max: 5, onChanged: (v) => values.add(v));
      await tester.pumpWidget(TestApp(widget: spinBox));
    });

    tearDownUI((tester) async {
      values.close();
    });

    testUI('increment', (tester) async {
      final center = tester.getCenter(find.increment);
      final gesture = await tester.startGesture(center);
      await tester.pumpAndSettle(kLongPressTimeout);

      await expectLater(
          values.stream, emitsInOrder([for (double i = 1; i <= 5; ++i) i]));
      gesture.up();
    });

    testUI('decrement', (tester) async {
      final center = tester.getCenter(find.decrement);
      final gesture = await tester.startGesture(center);
      await tester.pumpAndSettle(kLongPressTimeout);

      await expectLater(
          values.stream, emitsInOrder([for (double i = -1; i <= -5; --i) i]));
      gesture.up();
    });
  });
}
