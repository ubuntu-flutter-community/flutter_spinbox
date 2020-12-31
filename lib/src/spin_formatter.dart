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

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// ignore_for_file: public_member_api_docs

class SpinFormatter extends TextInputFormatter {
  SpinFormatter({required this.min, required this.max, required this.decimals});

  final double min;
  final double max;
  final int decimals;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final input = newValue.text;
    if (input.isEmpty) {
      return newValue;
    }

    final minus = input.startsWith('-');
    if (minus && min >= 0) {
      return oldValue;
    }

    final plus = input.startsWith('+');
    if (plus && max < 0) {
      return oldValue;
    }

    if ((minus || plus) && input.length == 1) {
      return newValue;
    }

    if (decimals <= 0 && !_validateValue(int.tryParse(input))) {
      return oldValue;
    }

    if (decimals > 0 && !_validateValue(double.tryParse(input))) {
      return oldValue;
    }

    final dot = input.lastIndexOf('.');
    if (dot >= 0 && decimals < input.substring(dot + 1).length) {
      return oldValue;
    }

    return newValue;
  }

  bool _validateValue(num? value) {
    if (value == null) {
      return false;
    }

    if (value >= min && value <= max) {
      return true;
    }

    if (value >= 0) {
      return value <= max;
    } else {
      return value >= min;
    }
  }
}
