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

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'spin_formatter.dart';

// ignore_for_file: public_member_api_docs

abstract class BaseSpinBox extends StatefulWidget {
  BaseSpinBox({Key key}) : super(key: key);

  double get min;
  double get max;
  double get step;
  double get value;
  int get decimals;
  ValueChanged<double> get onChanged;
}

abstract class BaseSpinBoxState<T extends BaseSpinBox> extends State<T> {
  double _value;
  double _cachedValue;
  FocusNode _focusNode;
  TextEditingController _controller;

  double get value => _value;
  bool get hasFocus => _focusNode?.hasFocus ?? false;
  FocusNode get focusNode => _focusNode;
  TextEditingController get controller => _controller;
  SpinFormatter get formatter => SpinFormatter(
      min: widget.min, max: widget.max, decimals: widget.decimals);

  static double _parseValue(String text) => double.tryParse(text) ?? 0;
  String _formatText(double value) => value.toStringAsFixed(widget.decimals);

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _cachedValue = widget.value;
    _controller = TextEditingController(text: _formatText(_value));
    _controller.addListener(_updateValue);
    _focusNode = FocusNode(onKey: (node, event) => _handleKey(event));
    _focusNode.addListener(() => setState(_selectAll));
    _focusNode.addListener(makeTextEditValidOnFocusChanged);
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _focusNode = null;
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  bool _handleKey(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      return event is RawKeyUpEvent || setValue(value + widget.step);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      return event is RawKeyUpEvent || setValue(value - widget.step);
    }
    return false;
  }

  void _updateValue() {
    final v = _parseValue(_controller.text);
    if (v == _value) return;
    setState(() => _value = v);
    widget.onChanged?.call(v);
  }

  bool setValue(double newValue) {
    newValue = newValue?.clamp(widget.min, widget.max);
    if (newValue == null || newValue == value) return false;
    _cachedValue = newValue;
    final text = _formatText(newValue);
    final selection = _controller.selection;
    final oldOffset = value.isNegative ? 1 : 0;
    final newOffset = _parseValue(text).isNegative ? 1 : 0;
    setState(() {
      _controller.value = _controller.value.copyWith(
        text: text,
        selection: selection.copyWith(
          baseOffset: selection.baseOffset - oldOffset + newOffset,
          extentOffset: selection.extentOffset - oldOffset + newOffset,
        ),
      );
    });
    return true;
  }

  void makeTextEditValidOnSubmit(String newValue) {
    if (newValue.isEmpty || widget.min < 0 && newValue == '-') {
      _controller.text = _formatText(_cachedValue); // will trigger notify to _updateValue()
    } else {
      _cachedValue = _value;
    }
  }

  void makeTextEditValidOnFocusChanged() {
    if (hasFocus) return;
    if (_controller.text == "" || widget.min < 0 && _controller.text == '-') {
      _controller.text = _formatText(_cachedValue); // will trigger notify to _updateValue()
    } else {
      _cachedValue = _value;
    }
  }

  void _selectAll() {
    if (!_focusNode.hasFocus) return;
    _controller.selection = _controller.selection
        .copyWith(baseOffset: 0, extentOffset: _controller.text.length);
  }
}
