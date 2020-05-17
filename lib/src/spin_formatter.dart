// MIT License
//
// Copyright (c) 2020 J-P Nurmi <jpnurmi@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

@visibleForTesting
class SpinFormatter extends TextInputFormatter {
  SpinFormatter({this.min, this.max, this.decimals});

  final double min;
  final double max;
  final int decimals;

  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    final input = newValue.text;
    if (input.isEmpty || (min < 0 && input == '-')) {
      return newValue;
    }
    final value = double.tryParse(input);
    if (value == null ||
        value < min ||
        value > max ||
        (decimals <= 0 && input.contains('.'))) {
      return oldValue;
    }
    if (!input.endsWith('.')) {
      var pattern = NumberFormat.decimalPattern();
      pattern.minimumFractionDigits = decimals;
      pattern.maximumFractionDigits = decimals;
      pattern.turnOffGrouping();
      final format = pattern.format(value);
      if (format.length < input.length) {
        return oldValue;
      }
    }
    return newValue;
  }
}
