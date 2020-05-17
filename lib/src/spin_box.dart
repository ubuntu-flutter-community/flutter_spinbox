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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'spin_button.dart';
import 'spin_formatter.dart';

class SpinBox extends StatefulWidget {
  SpinBox({
    Key key,
    this.min = 0,
    this.max = 99,
    this.step = 1,
    this.value = 0,
    this.interval = const Duration(milliseconds: 100),
    this.acceleration,
    this.decimals = 0,
    this.enabled = true,
    this.autofocus = false,
    TextInputType inputType,
    this.inputAction,
    InputDecoration inputDecoration,
    this.inputValidator,
    TextInputFormatter inputFormatter,
    this.keyboardAppearance,
    Icon incrementIcon,
    Icon decrementIcon,
    this.direction = Axis.horizontal,
    this.textAlign = TextAlign.center,
    this.textStyle,
    this.toolbarOptions,
    this.showCursor,
    this.enableInteractiveSelection = true,
    this.spacing = 16,
    this.onChanged,
  })  : assert(min != null),
        assert(max != null),
        assert(value != null),
        assert(interval != null),
        assert(direction != null),
        inputType = inputType ??
            TextInputType.numberWithOptions(
              signed: min < 0,
              decimal: decimals > 0,
            ),
        inputDecoration = inputDecoration ?? const InputDecoration(),
        inputFormatter = inputFormatter ??
            SpinFormatter(
              min: min,
              max: max,
              decimals: decimals,
            ),
        incrementIcon = incrementIcon ?? Icon(Icons.add),
        decrementIcon = decrementIcon ?? Icon(Icons.remove),
        super(key: key);

  final double min;
  final double max;
  final double step;
  final double value;
  final Duration interval;
  final double acceleration;
  final int decimals;
  final bool enabled;
  final bool autofocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextInputFormatter inputFormatter;
  final InputDecoration inputDecoration;
  final FormFieldValidator<String> inputValidator;
  final Brightness keyboardAppearance;
  final Icon incrementIcon;
  final Icon decrementIcon;
  final Axis direction;
  final double spacing;
  final bool showCursor;
  final bool enableInteractiveSelection;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final ToolbarOptions toolbarOptions;
  final ValueChanged<double> onChanged;

  @override
  SpinBoxState createState() => SpinBoxState();
}

@visibleForTesting
class SpinBoxState extends State<SpinBox> {
  double _value;
  FocusNode _focusNode;
  TextEditingController _controller;

  double get value => _value;

  static double _parseValue(String text) => double.tryParse(text) ?? 0;
  String _formatText(double value) => value.toStringAsFixed(widget.decimals);

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _controller = TextEditingController(text: _formatText(_value));
    _controller.addListener(_updateValue);
    _focusNode = FocusNode(onKey: (node, event) => _handleKey(event));
    _focusNode.addListener(_selectAll);
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _focusNode = null;
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorText = widget.inputValidator?.call(_controller.text);
    return Flex(
      direction: widget.direction,
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.up,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinButton(
          step: widget.step,
          icon: widget.decrementIcon,
          enabled: widget.enabled && value > widget.min,
          interval: widget.interval,
          acceleration: widget.acceleration,
          onStep: (step) => _setValue(value - step),
        ),
        SizedBox(width: widget.spacing, height: widget.spacing),
        Flexible(
          flex: widget.direction == Axis.horizontal ? 1 : 0,
          child: TextField(
            controller: _controller,
            style: widget.textStyle,
            textAlign: widget.textAlign,
            keyboardType: widget.inputType,
            textInputAction: widget.inputAction,
            toolbarOptions: widget.toolbarOptions,
            keyboardAppearance: widget.keyboardAppearance,
            inputFormatters: [widget.inputFormatter],
            decoration: widget.inputDecoration.copyWith(errorText: errorText),
            enableInteractiveSelection: widget.enableInteractiveSelection,
            showCursor: widget.showCursor,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            focusNode: _focusNode,
          ),
        ),
        SizedBox(width: widget.spacing, height: widget.spacing),
        SpinButton(
          step: widget.step,
          icon: widget.incrementIcon,
          enabled: widget.enabled && value < widget.max,
          interval: widget.interval,
          acceleration: widget.acceleration,
          onStep: (step) => _setValue(value + step),
        )
      ],
    );
  }

  bool _handleKey(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      return event is RawKeyUpEvent || _setValue(value + widget.step);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      return event is RawKeyUpEvent || _setValue(value - widget.step);
    }
    return false;
  }

  void _updateValue() {
    double v = _parseValue(_controller.text);
    if (v == _value) return;
    setState(() => _value = v);
    widget.onChanged?.call(v);
  }

  bool _setValue(double newValue) {
    newValue = newValue?.clamp(widget.min, widget.max);
    if (newValue == null || newValue == value) return false;
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

  void _selectAll() {
    if (!_focusNode.hasFocus) return;
    _controller.selection = _controller.selection
        .copyWith(baseOffset: 0, extentOffset: _controller.text.length);
  }
}
