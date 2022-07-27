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

import 'package:flutter/foundation.dart';

class SpinController extends ValueNotifier<double> {
  SpinController({
    required double min,
    required double max,
    required double value,
    this.decimals = 0,
  })  : _min = min,
        _max = max,
        super(value);

  double _min;
  double _max;

  final int decimals;

  double get min => _min;
  set min(double min) {
    _min = min;
    value = value.clamp(min, max);
  }

  double get max => _max;
  set max(double max) {
    _max = max;
    value = value.clamp(min, max);
  }

  void setRange(double min, double max) {
    _min = min;
    _max = max;
    value = value.clamp(min, max);
  }

  double? parse(String text) {
    if (decimals > 0) {
      return double.tryParse(text);
    }
    return int.tryParse(text)?.toDouble();
  }

  bool canChange(double value) => true;

  @override
  set value(double v) {
    final newValue = v.clamp(min, max);
    if (newValue != value && canChange(newValue)) {
      super.value = newValue;
    }
  }

  bool validate(String text) {
    if (text.isEmpty) {
      return true;
    }

    return _validateSign(text) &&
        _validateRange(text) &&
        _validateDecimalPoint(text);
  }

  bool _validateSign(String text) {
    final minus = text.startsWith('-');
    if (minus && min >= 0) {
      return false;
    }

    final plus = text.startsWith('+');
    if (plus && max < 0) {
      return false;
    }

    return true;
  }

  bool _validateRange(String text) {
    final value = parse(text);
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

  bool _validateDecimalPoint(String text) {
    final dot = text.lastIndexOf('.');
    if (dot >= 0 && decimals < text.substring(dot + 1).length) {
      return false;
    }

    return true;
  }
}
