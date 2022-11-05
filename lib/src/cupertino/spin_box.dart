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

import '../base_spin_box.dart';
import 'spin_button.dart';

part 'third_party/default_rounded_border.dart';

/// An iOS-style spinbox.
///
/// {@macro flutter_spinbox.SpinBox}
///
/// ![CupertinoSpinBox](https://raw.githubusercontent.com/jpnurmi/flutter_spinbox/main/doc/images/cupertino_spinbox.gif "CupertinoSpinBox")
///
/// ```dart
/// import 'package:flutter_spinbox/cupertino.dart'; // or flutter_spinbox.dart for both
///
/// CupertinoSpinBox(
///   min: 1,
///   max: 100,
///   value: 50,
///   onChanged: (value) => print(value),
/// )
/// ```
///
/// See also [Cupertino (iOS-style) widgets](https://flutter.dev/docs/development/ui/widgets/cupertino) package.
class CupertinoSpinBox extends BaseSpinBox {
  /// Creates a spinbox.
  CupertinoSpinBox({
    Key? key,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.pageStep,
    this.value = 0,
    this.interval = const Duration(milliseconds: 100),
    this.acceleration,
    this.digits = 0,
    this.decimals = 0,
    bool? enabled,
    this.readOnly = false,
    this.autofocus = false,
    TextInputType? keyboardType,
    this.textInputAction,
    this.padding = const EdgeInsets.all(6),
    this.decoration = _kDefaultRoundedBorderDecoration,
    this.keyboardAppearance,
    Icon? incrementIcon,
    Icon? decrementIcon,
    this.showButtons = true,
    this.prefix,
    this.suffix,
    this.direction = Axis.horizontal,
    this.textAlign = TextAlign.center,
    this.textStyle,
    this.toolbarOptions,
    this.showCursor,
    this.cursorColor,
    this.enableInteractiveSelection = true,
    this.spacing = 8,
    this.onChanged,
    this.onSubmitted,
    this.canChange,
    this.beforeChange,
    this.afterChange,
    this.focusNode,
  })  : assert(min <= max),
        keyboardType = keyboardType ??
            TextInputType.numberWithOptions(
              signed: min < 0,
              decimal: decimals > 0,
            ),
        enabled = (enabled ?? true) && min < max,
        //decoration = decoration ?? const BoxDecoration(),
        incrementIcon =
            incrementIcon ?? const Icon(CupertinoIcons.plus_circled),
        decrementIcon =
            decrementIcon ?? const Icon(CupertinoIcons.minus_circled),
        super(key: key);

  /// The minimum value the user can enter.
  ///
  /// Defaults to `0.0`. Must be less than or equal to [max].
  ///
  /// If min is equal to [max], the spinbox is disabled.
  @override
  final double min;

  /// The maximum value the user can enter.
  ///
  /// Defaults to `100.0`. Must be greater than or equal to [min].
  ///
  /// If max is equal to [min], the spinbox is disabled.
  @override
  final double max;

  /// The step size for incrementing and decrementing the value.
  ///
  /// Defaults to `1.0`.
  @override
  final double step;

  /// An optional page step size for incrementing and decrementing the value.
  ///
  /// Defaults to `null`.
  @override
  final double? pageStep;

  /// The current value.
  ///
  /// Defaults to `0.0`.
  @override
  final double value;

  /// The number of decimal places used for formatting the value.
  ///
  /// Defaults to `0`.
  @override
  final int decimals;

  /// The number of digits used for formatting the value.
  ///
  /// Defaults to `0`.
  @override
  final int digits;

  /// The interval used for auto-incrementing and -decrementing.
  ///
  /// When holding down the increment and decrement buttons, respectively.
  ///
  /// Defaults to `100` milliseconds.
  final Duration interval;

  /// The amount of acceleration that is added to the value on each step.
  ///
  /// When holding down the increment and decrement buttons, respectively.
  ///
  /// Defaults to `null` (no acceleration).
  final double? acceleration;

  /// The visual direction of the spinbox layout.
  ///
  /// In horizontal mode the increment and decrement buttons are on the sides,
  /// and in vertical mode the buttons are above and below the input field.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis direction;

  /// The visual spacing of the spinbox layout.
  ///
  /// In horizontal mode the increment and decrement buttons are on the sides,
  /// and in vertical mode the buttons are above and below the input field.
  ///
  /// Defaults to `8.0`.
  final double spacing;

  /// The visual icon for the increment button.
  ///
  /// Defaults to [CupertinoIcons.plus_circled].
  final Icon incrementIcon;

  /// The visual icon for the decrement button.
  ///
  /// Defaults to [CupertinoIcons.minus_circled].
  final Icon decrementIcon;

  /// Whether the increment and decrement buttons are shown.
  ///
  /// Defaults to `true`.
  final bool showButtons;

  /// See [CupertinoTextField.prefix].
  final Widget? prefix;

  /// See [CupertinoTextField.suffix].
  final Widget? suffix;

  /// See [TextField.focusNode].
  @override
  final FocusNode? focusNode;

  /// Called when the user has changed the value.
  @override
  final ValueChanged<double>? onChanged;

  @override
  final bool Function(double value)? canChange;

  @override
  final VoidCallback? beforeChange;

  @override
  final VoidCallback? afterChange;

  /// See [CupertinoTextField.enabled].
  final bool enabled;

  /// See [TextField.readOnly].
  @override
  final bool readOnly;

  /// See [CupertinoTextField.autofocus].
  final bool autofocus;

  /// See [CupertinoTextField.keyboardType].
  final TextInputType keyboardType;

  /// See [CupertinoTextField.textInputAction].
  final TextInputAction? textInputAction;

  /// See [CupertinoTextField.padding].
  final EdgeInsetsGeometry padding;

  /// See [CupertinoTextField.decoration].
  final BoxDecoration decoration;

  /// See [CupertinoTextField.keyboardAppearance].
  final Brightness? keyboardAppearance;

  /// See [CupertinoTextField.showCursor].
  final bool? showCursor;

  /// See [CupertinoTextField.cursorColor].
  final Color? cursorColor;

  /// See [CupertinoTextField.enableInteractiveSelection].
  final bool enableInteractiveSelection;

  /// See [CupertinoTextField.textAlign].
  final TextAlign textAlign;

  /// See [CupertinoTextField.style].
  final TextStyle? textStyle;

  /// See [CupertinoTextField.toolbarOptions].
  final ToolbarOptions? toolbarOptions;

  /// See [CupertinoTextField.onSubmitted]. Is called with a formatted value.
  @override
  final void Function(double)? onSubmitted;

  @override
  State<CupertinoSpinBox> createState() => _CupertinoSpinBoxState();
}

class _CupertinoSpinBoxState extends State<CupertinoSpinBox> with SpinBoxMixin {
  @override
  Widget build(BuildContext context) {
    final isHorizontal = widget.direction == Axis.horizontal;

    final textField = CallbackShortcuts(
      bindings: bindings,
      child: CupertinoTextField(
        controller: controller,
        style: widget.textStyle,
        textAlign: widget.textAlign,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        toolbarOptions: widget.toolbarOptions,
        keyboardAppearance: widget.keyboardAppearance,
        inputFormatters: [formatter],
        prefix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHorizontal && widget.showButtons)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpinPadding),
                child: Icon(null, size: widget.decrementIcon.size),
              ),
            if (widget.prefix != null) widget.prefix!,
          ],
        ),
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.suffix != null) widget.suffix!,
            if (isHorizontal && widget.showButtons)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpinPadding),
                child: Icon(null, size: widget.incrementIcon.size),
              ),
          ],
        ),
        padding: widget.padding,
        decoration: widget.decoration,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        showCursor: widget.showCursor,
        cursorColor: widget.cursorColor,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        focusNode: focusNode,
        onSubmitted: fixupValue,
      ),
    );

    if (!widget.showButtons) return textField;

    final incrementButton = CupertinoSpinButton(
      step: widget.step,
      icon: widget.incrementIcon,
      enabled: widget.enabled && value < widget.max,
      interval: widget.interval,
      acceleration: widget.acceleration,
      onStep: (step) => setValue(value + step),
    );

    final decrementButton = CupertinoSpinButton(
      step: widget.step,
      icon: widget.decrementIcon,
      enabled: widget.enabled && value > widget.min,
      interval: widget.interval,
      acceleration: widget.acceleration,
      onStep: (step) => setValue(value - step),
    );

    if (isHorizontal) {
      return Stack(
        alignment: Alignment.center,
        children: [
          textField,
          Center(
            child: Align(
              alignment: Alignment.centerLeft,
              child: decrementButton,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: incrementButton,
          )
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          incrementButton,
          SizedBox(height: widget.spacing),
          textField,
          SizedBox(height: widget.spacing),
          decrementButton,
        ],
      );
    }
  }
}
