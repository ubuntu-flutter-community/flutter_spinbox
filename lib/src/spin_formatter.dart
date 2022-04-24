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
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ignore_for_file: public_member_api_docs

NumberFormat buildNumberFormat(int? decimals, int? digits) {
  final numberFormat = decimals != null && decimals > 0
      ? NumberFormat.decimalPattern()
      : NumberFormat();
  numberFormat.minimumFractionDigits = decimals ?? 0;
  numberFormat.maximumFractionDigits = decimals ?? 0;
  if (digits != null) {
    numberFormat.minimumIntegerDigits = digits;
  }
  return numberFormat;
}

class SpinFormatter extends TextInputFormatter {
  SpinFormatter({required this.min, required this.max, required this.format});

  final double min;
  final double max;
  final NumberFormat format;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final input = newValue.text;
    if (input.isEmpty) {
      return newValue;
    }

    if (!_validateValue(input)) {
      return oldValue;
    }

    return newValue;
  }

  bool _validateValue(String input) {
    try {
      final value = format.parse(input);
      if (value >= min && value <= max) {
        return true;
      }

      if (value >= 0) {
        return value <= max;
      } else {
        return value >= min;
      }
    } on FormatException catch (e) {
      print(e);
      return false;
    }
  }
}
