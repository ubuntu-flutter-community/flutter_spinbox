import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

import 'test_spinbox.dart';

class TestApp extends MaterialApp {
  TestApp({Key key, Widget widget})
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
}
