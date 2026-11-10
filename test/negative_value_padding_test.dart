import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(SpinBox spinBox) {
  return MaterialApp(home: Scaffold(body: Center(child: spinBox)));
}

void main() {
  testWidgets('negative zero padding keeps the sign', (tester) async {
    await tester.pumpWidget(_app(SpinBox(min: -10, value: -3, digits: 4)));
    final state = tester.state<SpinBoxState>(find.byType(SpinBox));
    expect(state.controller.text, '-003');

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(state.value, -2);
    expect(state.controller.text, '-002');
  });
}
