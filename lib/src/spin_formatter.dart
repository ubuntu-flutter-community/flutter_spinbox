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

// ignore_for_file: public_member_api_docs

class SpinFormatter extends TextInputFormatter {
  SpinFormatter({required this.min, required this.max, required this.decimals});

  final double min;
  final double max;
  final int decimals;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final input = newValue.text;
    if (input.isEmpty) {
      return newValue;
    }

    // Allow only negative sign at the start
    final minus = input.startsWith('-');
    if (minus && min >= 0) {
      return oldValue;
    }

    // Allow only positive sign at the start
    final plus = input.startsWith('+');
    if (plus && max < 0) {
      return oldValue;
    }

    // Allow only the sign
    if ((minus || plus) && input.length == 1) {
      return newValue;
    }

    // Allow only a decimal point
    if (input == '.' || input == '-.' || input == '+.') {
      return TextEditingValue(
        text: input == '.' ? '0.' : (input == '-.' ? '-0.' : '+0.'),
        selection: TextSelection.collapsed(offset: input.length + 1),
      );
    }

    // Verify if it's a valid number
    bool isValidNumber = false;
    num? parsedValue;

    if (decimals <= 0) {
      parsedValue = int.tryParse(input);
      isValidNumber = _validateValue(parsedValue);
    } else {
      // Allow partial decimal entry
      if (input.endsWith('.')) {
        // Allow ending with decimal point
        String valueToCheck = input.substring(0, input.length - 1);
        if (valueToCheck.isEmpty || valueToCheck == '-' || valueToCheck == '+') {
          valueToCheck = '${valueToCheck}0';
        }
        parsedValue = double.tryParse(valueToCheck);
        isValidNumber = _validateValue(parsedValue);
      } else {
        parsedValue = double.tryParse(input);
        isValidNumber = _validateValue(parsedValue);
      }
    }

    if (!isValidNumber) {
      return oldValue;
    }

    // Verify number of decimals
    final dot = input.lastIndexOf('.');
    if (dot >= 0) {
      final decimalPart = input.substring(dot + 1);
      if (decimals < decimalPart.length) {
        return oldValue;
      }
    }

    return newValue;
  }

  bool _validateValue(num? value) {
    if (value == null) {
      return false;
    }

    // If the value is within the range, it is valid
    if (value >= min && value <= max) {
      return true;
    }

    // Allow partial values during editing
    if (value >= 0) {
      return value <= max;
    } else {
      return value >= min;
    }
  }
}
