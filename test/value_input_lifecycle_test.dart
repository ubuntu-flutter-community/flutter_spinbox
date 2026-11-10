import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(SpinBox spinBox) {
  return MaterialApp(home: Scaffold(body: Center(child: spinBox)));
}

void main() {
  testWidgets('button step sends one numeric change callback', (tester) async {
    final changes = <double>[];
    await tester.pumpWidget(
      _app(SpinBox(value: 2, onChanged: changes.add)),
    );
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(changes, <double>[3]);
  });

  testWidgets('step rounding never escapes fractional bounds', (tester) async {
    await tester.pumpWidget(
      _app(SpinBox(max: 0.29, value: 0.2, step: 0.1, decimals: 1)),
    );
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    final state = tester.state<SpinBoxState>(find.byType(SpinBox));
    expect(state.value, 0.2);
    expect(state.controller.text, '0.2');
  });

  testWidgets('non-finite programmatic steps are ignored', (tester) async {
    final changes = <double>[];
    await tester.pumpWidget(
      _app(SpinBox(value: 5, onChanged: changes.add)),
    );
    final state = tester.state<SpinBoxState>(find.byType(SpinBox));

    state.setValue(double.nan);
    state.setValue(double.infinity);
    state.setValue(double.negativeInfinity);
    await tester.pump();

    expect(state.value, 5);
    expect(state.controller.text, '5');
    expect(changes, isEmpty);
  });
}
