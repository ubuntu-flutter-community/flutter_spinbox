import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

import 'test_spinbox.dart';

class TestApp extends MaterialApp {
  TestApp(Widget widget) : super(home: Scaffold(body: widget));
}

void main() {
  TestIcons.increment = Icons.add;
  TestIcons.decrement = Icons.remove;

  testDefaults<SpinBox>(() {
    return TestApp(SpinBox());
  });

  testTap<SpinBox>(() {
    return TestApp(SpinBox(value: 1));
  });

  testInput<SpinBox>(() {
    return TestApp(SpinBox(value: 1, autofocus: true));
  });

  testDecimals<SpinBox>(() {
    return TestApp(SpinBox(min: -1, max: 1, value: 0.5, decimals: 2));
  });

  testCallbacks<SpinBox>((onChanged) {
    return TestApp(SpinBox(value: 1, onChanged: onChanged));
  });

  testLongPress<SpinBox>((onChanged) {
    return TestApp(SpinBox(min: -5, max: 5, onChanged: onChanged));
  });
}
