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
import 'package:flutter/widgets.dart';

import 'spin_formatter.dart';

// ignore_for_file: public_member_api_docs

abstract class BaseSpinBox extends StatefulWidget {
  const BaseSpinBox({super.key});

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
  late FocusNode _focusNode;
  late final TextEditingController _controller;
  late SpinFormatter _formatter;
  late Map<ShortcutActivator, VoidCallback> _bindings;
  bool _updatingController = false;

  double get value => _value;
  bool get hasFocus => _focusNode.hasFocus;
  FocusNode get focusNode => _focusNode;
  TextEditingController get controller => _controller;
  SpinFormatter get formatter => _formatter;
  Map<ShortcutActivator, VoidCallback> get bindings => _bindings;

  String _formatText(double value) {
    return value.toStringAsFixed(widget.decimals).padLeft(widget.digits, '0');
  }

  SpinFormatter _createFormatter() => SpinFormatter(
        min: widget.min,
        max: widget.max,
        decimals: widget.decimals,
      );

  Map<ShortcutActivator, VoidCallback> _createBindings() {
    return {
      // ### TODO: use SingleActivator fixed in Flutter 2.10+
      // https://github.com/flutter/flutter/issues/92717
      LogicalKeySet(LogicalKeyboardKey.arrowUp): _stepUp,
      LogicalKeySet(LogicalKeyboardKey.arrowDown): _stepDown,
      if (widget.pageStep != null) ...{
        LogicalKeySet(LogicalKeyboardKey.pageUp): _pageStepUp,
        LogicalKeySet(LogicalKeyboardKey.pageDown): _pageStepDown,
      }
    };
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value.clamp(widget.min, widget.max);
    _cachedValue = _value;
    _formatter = _createFormatter();
    _bindings = _createBindings();
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
    if (_updatingController) return;
    // Empty input, a lone sign, or a decimal separator is incomplete text.
    // Keep the last numeric value rather than broadcasting a spurious zero.
    final parsed = double.tryParse(_controller.text);
    if (parsed == null || !parsed.isFinite || parsed == _value) return;

    if (widget.canChange?.call(parsed) == false) {
      final previous =
          _value >= widget.min && _value <= widget.max ? _value : _cachedValue;
      _updateController(_value, previous);
      if (previous != _value) setState(() => _value = previous);
      return;
    }

    setState(() => _value = parsed);
    // A temporarily out-of-range number is allowed while typing, but must
    // not trigger expensive client-side work until it is a valid value.
    if (parsed >= widget.min && parsed <= widget.max) {
      _cachedValue = parsed;
      widget.onChanged?.call(parsed);
    }
  }

  void setValue(double v) {
    if (!v.isFinite) return;
    final clamped = v.clamp(widget.min, widget.max);
    final newValue = double.parse(_formatText(clamped));
    // Formatting can round a value beyond a fractional bound (for example
    // 0.29 becomes 0.3 with one decimal place). Never submit an invalid step.
    if (!newValue.isFinite ||
        newValue < widget.min ||
        newValue > widget.max ||
        newValue == _value) {
      return;
    }
    if (widget.canChange?.call(newValue) == false) return;

    widget.beforeChange?.call();
    setState(() {
      _updateController(_value, newValue);
      _value = _cachedValue = newValue;
    });
    widget.onChanged?.call(newValue);
    widget.onSubmitted?.call(newValue);
    widget.afterChange?.call();
  }

  void _updateController(double oldValue, double newValue) {
    final text = _formatText(newValue);
    final selection = _controller.selection;
    final oldOffset = oldValue.isNegative ? 1 : 0;
    final newOffset = newValue.isNegative ? 1 : 0;

    final updatedSelection = selection.isValid
        ? selection.copyWith(
            baseOffset: (selection.baseOffset - oldOffset + newOffset)
                .clamp(0, text.length),
            extentOffset: (selection.extentOffset - oldOffset + newOffset)
                .clamp(0, text.length),
          )
        : selection;

    // Updating the text controller already notifies EditableText. Suppress
    // our own listener to avoid a second setState/onChanged per button press.
    _updatingController = true;
    try {
      _controller.value = _controller.value.copyWith(
        text: text,
        selection: updatedSelection,
        composing: TextRange.empty,
      );
    } finally {
      _updatingController = false;
    }
  }

  @protected
  double fixupValue(String text) {
    final parsed = double.tryParse(text);
    if (parsed == null ||
        !parsed.isFinite ||
        parsed < widget.min ||
        parsed > widget.max) {
      _updateController(_value, _cachedValue);
      _value = _cachedValue;
    } else {
      _value = _cachedValue = parsed;
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

    // A parent can replace an externally owned FocusNode without replacing
    // this widget's State. Rebind to the new node and release owned nodes.
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChanged);
    }

    final boundsChanged =
        oldWidget.min != widget.min || oldWidget.max != widget.max;
    final precisionChanged = oldWidget.decimals != widget.decimals;
    final digitsChanged = oldWidget.digits != widget.digits;
    if (boundsChanged || precisionChanged) {
      _formatter = _createFormatter();
    }
    if ((oldWidget.pageStep == null) != (widget.pageStep == null)) {
      _bindings = _createBindings();
    }

    if (oldWidget.value != widget.value) {
      final nextValue = widget.value.clamp(widget.min, widget.max);
      // Preserve a user's partially formatted text and cursor when a
      // controlled parent echoes the same numeric value on each keystroke.
      final sameEditingValue = hasFocus &&
          !precisionChanged &&
          !digitsChanged &&
          double.tryParse(_controller.text) == nextValue;
      if (!sameEditingValue) _updateController(_value, nextValue);
      _value = _cachedValue = nextValue;
    } else if (boundsChanged || precisionChanged || digitsChanged) {
      final nextValue = _value.clamp(widget.min, widget.max);
      if (nextValue != _value || precisionChanged || digitsChanged) {
        _updateController(_value, nextValue);
        _value = _cachedValue = nextValue;
      } else {
        _cachedValue = _cachedValue.clamp(widget.min, widget.max);
      }
    }
  }
}
