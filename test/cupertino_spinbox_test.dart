import 'package:flutter/cupertino.dart';
import 'package:flutter_spinbox/cupertino.dart';

import 'test_spinbox.dart';

class TestApp extends CupertinoApp {
  TestApp(Widget widget) : super(home: CupertinoPageScaffold(child: widget));
}

void main() {
  TestIcons.increment = CupertinoIcons.plus_circled;
  TestIcons.decrement = CupertinoIcons.minus_circled;

  testDefaults<CupertinoSpinBox>(() {
    return TestApp(CupertinoSpinBox());
  });

  testTap<CupertinoSpinBox>(() {
    return TestApp(CupertinoSpinBox(value: 1));
  });

  testInput<CupertinoSpinBox>(() {
    return TestApp(CupertinoSpinBox(value: 1, autofocus: true));
  });

  testRange<CupertinoSpinBox>(() {
    return TestApp(
        CupertinoSpinBox(min: 10, max: 30, value: 20, autofocus: true));
  });

  testDecimals<CupertinoSpinBox>(() {
    return TestApp(CupertinoSpinBox(
        min: -1, max: 1, value: 0.5, decimals: 2, autofocus: true));
  });

  testCallbacks<CupertinoSpinBox>((onChanged) {
    return TestApp(CupertinoSpinBox(value: 1, onChanged: onChanged));
  });

  testLongPress<CupertinoSpinBox>((onChanged) {
    return TestApp(CupertinoSpinBox(min: -5, max: 5, onChanged: onChanged));
  });
}
