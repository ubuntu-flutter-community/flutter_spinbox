import 'package:flutter_spinbox/src/spin_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a decimal separator can start fractional input', () {
    final formatter = SpinFormatter(min: -10, max: 10, decimals: 2);
    const oldValue = TextEditingValue(text: '0');
    const dot = TextEditingValue(text: '.');
    const signedDot = TextEditingValue(text: '-.');
    expect(formatter.formatEditUpdate(oldValue, dot), dot);
    expect(formatter.formatEditUpdate(oldValue, signedDot), signedDot);
  });
}
