import 'package:flutter_spinbox/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('icon size participates in theme equality and hash code', () {
    const small = SpinBoxThemeData(iconSize: 16);
    const large = SpinBoxThemeData(iconSize: 32);
    const same = SpinBoxThemeData(iconSize: 16);

    expect(small, equals(same));
    expect(small.hashCode, same.hashCode);
    expect(small, isNot(equals(large)));
    expect(small.hashCode, isNot(large.hashCode));
  });
}
