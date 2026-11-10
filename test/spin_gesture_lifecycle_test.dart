import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/src/spin_gesture.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required ValueChanged<double> onStep,
  bool enabled = true,
  double step = 1,
  Duration interval = const Duration(milliseconds: 100),
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SpinGesture(
          enabled: enabled,
          step: step,
          interval: interval,
          onStep: onStep,
          child: const ColoredBox(
            color: Colors.blue,
            child: SizedBox(width: 80, height: 80),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('cancel stops repeated callbacks', (tester) async {
    final changes = <double>[];
    await tester.pumpWidget(_harness(onStep: changes.add));

    final center = tester.getCenter(find.byType(SpinGesture));
    final gesture = await tester.startGesture(center);
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 200));
    expect(changes, isNotEmpty);

    await gesture.cancel();
    await tester.pump();
    final count = changes.length;
    await tester.pump(const Duration(seconds: 1));
    expect(changes, hasLength(count));
  });

  testWidgets('disable stops repeated callbacks', (tester) async {
    final changes = <double>[];
    await tester.pumpWidget(_harness(onStep: changes.add));

    final center = tester.getCenter(find.byType(SpinGesture));
    final gesture = await tester.startGesture(center);
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 200));
    expect(changes, isNotEmpty);

    await tester.pumpWidget(_harness(onStep: changes.add, enabled: false));
    final count = changes.length;
    await tester.pump(const Duration(seconds: 1));
    expect(changes, hasLength(count));
    await gesture.up();
  });

  testWidgets('a changed step is used on the next press', (tester) async {
    final changes = <double>[];
    await tester.pumpWidget(_harness(onStep: changes.add));
    await tester.pumpWidget(_harness(onStep: changes.add, step: 3));

    final center = tester.getCenter(find.byType(SpinGesture));
    final gesture = await tester.startGesture(center);
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 150));

    expect(changes, isNotEmpty);
    expect(changes.first, 3);
    await gesture.up();
  });

  testWidgets('a step changed while held keeps spinning with the new step', (
    tester,
  ) async {
    final changes = <double>[];
    await tester.pumpWidget(_harness(onStep: changes.add));

    final center = tester.getCenter(find.byType(SpinGesture));
    final gesture = await tester.startGesture(center);
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 150));
    expect(changes, isNotEmpty);

    await tester.pumpWidget(_harness(onStep: changes.add, step: 3));
    final count = changes.length;
    await tester.pump(const Duration(milliseconds: 350));
    expect(changes.skip(count), [3, 3, 3]);
    await gesture.up();
  });

  testWidgets('zero interval does not create a busy timer', (tester) async {
    final changes = <double>[];
    await tester.pumpWidget(
      _harness(onStep: changes.add, interval: Duration.zero),
    );
    final center = tester.getCenter(find.byType(SpinGesture));
    final gesture = await tester.startGesture(center);
    await tester.pump(kLongPressTimeout + const Duration(seconds: 1));
    expect(changes, isEmpty);
    await gesture.up();
  });
}
