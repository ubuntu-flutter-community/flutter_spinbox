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

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'spin_formatter.dart';

// ignore_for_file: public_member_api_docs

abstract class BaseSpinBox extends StatefulWidget {
  const BaseSpinBox({Key? key}) : super(key: key);

  double get min;
  double get max;
  double get step;
  double? get pageStep;
  double get value;
  int get decimals;
  int get digits;
  void Function(double)? get onSubmitted;
  ValueChanged<double>? get onChanged;
  bool Function(double value)? get canChange;
  VoidCallback? get beforeChange;
  VoidCallback? get afterChange;
  bool get readOnly;
  FocusNode? get focusNode;
}

mixin SpinBoxMixin<T extends BaseSpinBox> on State<T> {
  late double _value;
  late double _cachedValue;
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  double get value => _value;
  bool get hasFocus => _focusNode.hasFocus;
  FocusNode get focusNode => _focusNode;
  TextEditingController get controller => _controller;
  SpinFormatter get formatter => SpinFormatter(
      min: widget.min, max: widget.max, decimals: widget.decimals);

  static double _parseValue(String text) => double.tryParse(text) ?? 0;
  String _formatText(double value) {
    // If decimals are 0 or the value has no decimal part, show as integer
    if (widget.decimals <= 0 || value == value.truncateToDouble()) {
      return value.toInt().toString().padLeft(widget.digits, '0');
    }

    // Format with decimals but remove trailing zeros
    String formatted = value.toStringAsFixed(widget.decimals);
    if (formatted.contains('.')) {
      // Remove trailing zeros
      while (formatted.endsWith('0')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      // Remove the decimal point if it's the last character
      if (formatted.endsWith('.')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
    }
    return formatted.padLeft(widget.digits, '0');
  }

  Map<ShortcutActivator, VoidCallback> get bindings {
    return {
      // Using SingleActivator as fixed in Flutter 2.10+
      const SingleActivator(LogicalKeyboardKey.arrowUp): _stepUp,
      const SingleActivator(LogicalKeyboardKey.arrowDown): _stepDown,
      if (widget.pageStep != null) ...{
        const SingleActivator(LogicalKeyboardKey.pageUp): _pageStepUp,
        const SingleActivator(LogicalKeyboardKey.pageDown): _pageStepDown,
      }
    };
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _cachedValue = widget.value;
    _controller = TextEditingController(text: _formatText(_value));
    _controller.addListener(_updateValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void _stepUp() => setValue(value + widget.step);
  void _stepDown() => setValue(value - widget.step);

  void _pageStepUp() => setValue(value + widget.pageStep!);
  void _pageStepDown() => setValue(value - widget.pageStep!);

  void _updateValue() {
    final v = _parseValue(_controller.text);
    if (v == _value) return;

    if (widget.canChange?.call(v) == false) {
      controller.text = _formatText(_cachedValue);
      setState(() {
        _value = _cachedValue;
      });
      return;
    }

    setState(() => _value = v);
    widget.onChanged?.call(v);
  }

  void setValue(double v) {
    final newValue = v.clamp(widget.min, widget.max);
    if (newValue == value) return;

    if (widget.canChange?.call(newValue) == false) return;

    widget.beforeChange?.call();
    setState(() => _updateController(value, newValue));
    widget.onSubmitted?.call(double.parse(_formatText(newValue)));
    widget.afterChange?.call();
  }

  void _updateController(double oldValue, double newValue) {
    final text = _formatText(newValue);
    final selection = _controller.selection;
    final oldOffset = value.isNegative ? 1 : 0;
    final newOffset = _parseValue(text).isNegative ? 1 : 0;

    // Preserve cursor position when possible
    final cursorPos = selection.baseOffset;
    if (cursorPos >= 0 && cursorPos <= _controller.text.length) {
      _controller.value = _controller.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(
          offset: min(cursorPos, text.length),
        ),
      );
    } else {
      _controller.value = _controller.value.copyWith(
        text: text,
        selection: selection.copyWith(
          baseOffset: selection.baseOffset - oldOffset + newOffset,
          extentOffset: selection.extentOffset - oldOffset + newOffset,
        ),
      );
    }
  }

  @protected
  double fixupValue(String value) {
    final v = _parseValue(value);
    if (value.isEmpty || (v < widget.min || v > widget.max)) {
      // will trigger notify to _updateValue()
      _controller.text = _formatText(_cachedValue);
    } else {
      _cachedValue = _value;
    }
    return _cachedValue;
  }

  void _handleFocusChanged() {
    setState(() {
      if (hasFocus) {
        _selectAll();
      } else {
        final value = fixupValue(_controller.text);
        widget.onSubmitted?.call(value);
      }
    });
  }

  void _selectAll() {
    _controller.selection = _controller.selection
        .copyWith(baseOffset: 0, extentOffset: _controller.text.length);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.removeListener(_updateValue);
      _value = _cachedValue = widget.value;
      _updateController(oldWidget.value, widget.value);
      _controller.addListener(_updateValue);
    }
  }
}
