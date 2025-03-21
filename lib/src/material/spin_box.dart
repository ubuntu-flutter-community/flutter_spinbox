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

import 'package:flutter/material.dart';

import '../base_spin_box.dart';
import 'spin_box_theme.dart';
import 'spin_button.dart';

/// A material design spinbox.
///
/// {@macro flutter_spinbox.SpinBox}
///
/// ![SpinBox](https://raw.githubusercontent.com/jpnurmi/flutter_spinbox/main/doc/images/spinbox.gif "SpinBox")
///
/// ```dart
/// import 'package:flutter_spinbox/material.dart'; // or flutter_spinbox.dart for both
///
/// SpinBox(
///   min: 1,
///   max: 100,
///   value: 50,
///   onChanged: (value) => print(value),
/// )
/// ```
///
/// See also [Material Components widgets](https://flutter.dev/docs/development/ui/widgets/material) package.
class SpinBox extends BaseSpinBox {
  /// Creates a spinbox.
  SpinBox({
    Key? key,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.pageStep,
    this.value = 0,
    this.interval = const Duration(milliseconds: 100),
    this.acceleration,
    this.decimals = 0,
    this.digits = 0,
    bool? enabled,
    this.readOnly = false,
    this.autofocus = false,
    TextInputType? keyboardType,
    this.textInputAction,
    this.decoration,
    this.validator,
    this.keyboardAppearance,
    Icon? incrementIcon,
    Icon? decrementIcon,
    this.iconSize,
    this.iconColor,
    this.showButtons = true,
    this.direction = Axis.horizontal,
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.ltr,
    this.textStyle,
    this.contextMenuBuilder,
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
        incrementIcon = incrementIcon ?? const Icon(Icons.add),
        decrementIcon = decrementIcon ?? const Icon(Icons.remove),
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
  /// Defaults to [Icons.add].
  final Icon incrementIcon;

  /// The visual icon for the decrement button.
  ///
  /// Defaults to [Icons.remove].
  final Icon decrementIcon;

  /// The size to use for [incrementIcon] and [decrementIcon].
  ///
  /// If `null`, then the value of [SpinBoxThemeData.iconSize] is used. If
  /// that is also `null`, then a pre-defined default is used.
  final double? iconSize;

  /// The color to use for [incrementIcon] and [decrementIcon].
  ///
  /// If `null`, then the value of [SpinBoxThemeData.iconColor] is used. If
  /// that is also `null`, then pre-defined defaults are used.
  final WidgetStateProperty<Color?>? iconColor;

  /// Whether the increment and decrement buttons are shown.
  ///
  /// Defaults to `true`.
  final bool showButtons;

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

  /// See [TextField.enabled].
  final bool enabled;

  /// See [TextField.readOnly].
  @override
  final bool readOnly;

  /// See [TextField.autofocus].
  final bool autofocus;

  /// See [TextField.keyboardType].
  final TextInputType keyboardType;

  /// See [TextField.textInputAction].
  final TextInputAction? textInputAction;

  /// See [TextField.decoration].
  final InputDecoration? decoration;

  /// See [FormField.validator].
  final FormFieldValidator<String>? validator;

  /// See [TextField.keyboardAppearance].
  final Brightness? keyboardAppearance;

  /// See [TextField.showCursor].
  final bool? showCursor;

  /// See [TextField.cursorColor].
  final Color? cursorColor;

  /// See [TextField.enableInteractiveSelection].
  final bool enableInteractiveSelection;

  /// See [TextField.textAlign].
  final TextAlign textAlign;

  /// See [TextField.textDirection].
  final TextDirection textDirection;

  /// See [TextField.style].
  final TextStyle? textStyle;

  /// See [TextField.contextMenuBuilder].
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// See [TextField.onSubmitted].
  ///
  /// Is also called when an increment or decrement button is pressed.
  ///
  /// Value is formatted.
  @override
  final void Function(double)? onSubmitted;

  @override
  State<SpinBox> createState() => SpinBoxState();
}

class SpinBoxState extends State<SpinBox> with SpinBoxMixin {
  Color? _iconColor(ThemeData theme, String? errorText) {
    if (!widget.enabled) return theme.disabledColor;
    if (hasFocus && errorText == null) return theme.colorScheme.primary;

    switch (theme.brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
      default:
        return theme.iconTheme.color;
    }
  }

  double _textHeight(String? text, TextStyle style) {
    final painter = TextPainter(
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      text: TextSpan(style: style, text: text),
    );
    painter.layout();
    return painter.height;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spinBoxTheme = SpinBoxTheme.of(context);

    final decoration = (widget.decoration ??
            spinBoxTheme?.decoration ??
            const InputDecoration())
        .applyDefaults(theme.inputDecorationTheme);

    final errorText =
        decoration.errorText ?? widget.validator?.call(controller.text);

    final iconSize = widget.iconSize ?? spinBoxTheme?.iconSize ?? 24;

    final iconColor = widget.iconColor ??
        spinBoxTheme?.iconColor ??
        WidgetStateProperty.all(_iconColor(theme, errorText));

    final states = <WidgetState>{
      if (!widget.enabled) WidgetState.disabled,
      if (hasFocus) WidgetState.focused,
      if (errorText != null) WidgetState.error,
    };

    final decrementStates = Set<WidgetState>.of(states);
    if (value <= widget.min) decrementStates.add(WidgetState.disabled);

    final incrementStates = Set<WidgetState>.of(states);
    if (value >= widget.max) incrementStates.add(WidgetState.disabled);

    var bottom = 0.0;
    final isHorizontal = widget.direction == Axis.horizontal;

    if (isHorizontal) {
      final caption = theme.textTheme.bodySmall;
      if (errorText != null) {
        bottom = _textHeight(errorText, caption!.merge(decoration.errorStyle));
      }
      if (decoration.helperText != null) {
        bottom = max(
            bottom,
            _textHeight(
                decoration.helperText, caption!.merge(decoration.helperStyle)));
      }
      if (decoration.counterText != null) {
        bottom = max(
            bottom,
            _textHeight(decoration.counterText,
                caption!.merge(decoration.counterStyle)));
      }
      if (bottom > 0) bottom += 8.0; // subTextGap
    }

    final hasAnyBorder = decoration.border != null ||
        decoration.errorBorder != null ||
        decoration.enabledBorder != null ||
        decoration.focusedBorder != null ||
        decoration.disabledBorder != null ||
        decoration.focusedErrorBorder != null;

    Widget buildIcon(
      Icon icon, {
      Widget? prefix,
      Widget? suffix,
    }) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (suffix != null) suffix,
          if (isHorizontal && widget.showButtons)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.spacing),
              child: SizedBox(width: icon.size ?? iconSize, height: 0),
            ),
          if (prefix != null) prefix,
        ],
      );
    }

    final inputDecoration = decoration.copyWith(
      border: !hasAnyBorder ? const OutlineInputBorder() : decoration.border,
      errorText: errorText,
      prefix: buildIcon(widget.decrementIcon, prefix: decoration.prefix),
      suffix: buildIcon(widget.incrementIcon, suffix: decoration.suffix),
    );

    final textField = CallbackShortcuts(
      bindings: bindings,
      child: TextField(
        controller: controller,
        style: widget.textStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        contextMenuBuilder: widget.contextMenuBuilder,
        keyboardAppearance: widget.keyboardAppearance,
        inputFormatters: [formatter],
        decoration: inputDecoration,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        showCursor: widget.showCursor,
        cursorColor: widget.cursorColor,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        focusNode: focusNode,
        onSubmitted: (v) {
          final value = fixupValue(v);
          widget.onSubmitted?.call(value);
        },
      ),
    );

    final incrementButton = SpinButton(
      step: widget.step,
      color: iconColor.resolve(incrementStates),
      icon: widget.incrementIcon,
      iconSize: widget.incrementIcon.size ?? iconSize,
      enabled: widget.enabled && value < widget.max,
      interval: widget.interval,
      acceleration: widget.acceleration,
      onStep: (step) => setValue(value + step),
    );

    if (!widget.showButtons) return textField;

    final decrementButton = SpinButton(
      step: widget.step,
      color: iconColor.resolve(decrementStates),
      icon: widget.decrementIcon,
      iconSize: widget.decrementIcon.size ?? iconSize,
      enabled: widget.enabled && value > widget.min,
      interval: widget.interval,
      acceleration: widget.acceleration,
      onStep: (step) => setValue(value - step),
    );

    if (isHorizontal) {
      return Stack(
        children: [
          textField,
          Positioned.fill(
            bottom: bottom,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.spacing),
                child: decrementButton,
              ),
            ),
          ),
          Positioned.fill(
            bottom: bottom,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.spacing),
                child: incrementButton,
              ),
            ),
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
