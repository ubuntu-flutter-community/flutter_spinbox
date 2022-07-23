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

import 'spin_controller.dart';
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
  ValueChanged<double>? get onChanged;
  bool get readOnly;
  FocusNode? get focusNode;
  SpinController? get controller;
}

mixin SpinBoxMixin<T extends BaseSpinBox> on State<T> {
  late final SpinController _controller;
  late final TextEditingController _editor;
  late final FocusNode _focusNode;

  SpinController get controller => _controller;
  TextEditingController get editor => _editor;
  FocusNode get focusNode => _focusNode;
  SpinFormatter get formatter => SpinFormatter(_controller);

  Map<ShortcutActivator, VoidCallback> get bindings {
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

  String _formatValue(double value) {
    return formatter.formatValue(value,
        decimals: widget.decimals, digits: widget.digits);
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        SpinController(
          min: widget.min,
          max: widget.max,
          value: widget.value,
          decimals: widget.decimals,
        );
    _controller.addListener(_handleValueChange);
    _editor = TextEditingController(text: _formatValue(widget.value));
    _editor.addListener(_handleTextChange);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.removeListener(_handleValueChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _editor.dispose();
    super.dispose();
  }

  void _stepUp() => controller.value += widget.step;
  void _stepDown() => controller.value -= widget.step;

  void _pageStepUp() => controller.value += widget.pageStep!;
  void _pageStepDown() => controller.value -= widget.pageStep!;

  void _handleValueChange() {
    widget.onChanged?.call(_controller.value);
    setState(() => _updateText(_controller.value));
  }

  void _handleTextChange() {
    final value = _controller.parse(_editor.text);
    if (value != null && value >= controller.min && value <= controller.max) {
      _controller.value = value;
    }
  }

  void _updateText(double value) {
    final text = _formatValue(value);
    final selection = _editor.selection;
    final oldOffset = _controller.value.isNegative ? 1 : 0;
    final newOffset = _controller.parse(text)?.isNegative == true ? 1 : 0;

    _editor.value = _editor.value.copyWith(
      text: text,
      selection: selection.copyWith(
        baseOffset: selection.baseOffset - oldOffset + newOffset,
        extentOffset: selection.extentOffset - oldOffset + newOffset,
      ),
    );
  }

  @protected
  void fixupValue(String text) {
    final value = _controller.parse(text);
    if (value == null) {
      _editor.text = _formatValue(_controller.value);
    } else if (value < _controller.min || value > _controller.max) {
      _controller.value = value.clamp(_controller.min, _controller.max);
    }
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      setState(_selectAll);
    } else {
      fixupValue(_editor.text);
    }
  }

  void _selectAll() {
    _editor.selection = _editor.selection
        .copyWith(baseOffset: 0, extentOffset: _editor.text.length);
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _editor.removeListener(_handleTextChange);
      _controller.value = widget.value;
      _updateText(widget.value);
      _editor.addListener(_handleTextChange);
    }
  }
}
