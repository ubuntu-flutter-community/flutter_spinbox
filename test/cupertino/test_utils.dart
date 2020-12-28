import 'package:flutter/cupertino.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class CupertinoTestApp extends CupertinoApp {
  CupertinoTestApp({Widget widget})
      : super(home: CupertinoPageScaffold(child: widget));
}

extension CupertinoSpinBoxFinders on CommonFinders {
  Finder get spinBox => byType(CupertinoSpinBox);
  Finder get textField => byType(CupertinoTextField);
  Finder get increment => byIcon(CupertinoIcons.plus_circled);
  Finder get decrement => byIcon(CupertinoIcons.minus_circled);
}

extension CupertinoSpinBoxFinder on Finder {
  Widget get widget => evaluate().first.widget;
  CupertinoTextField get textField => widget as CupertinoTextField;
  CupertinoSpinBox get spinBox => widget as CupertinoSpinBox;
  FocusNode get focusNode => textField.focusNode;
}

final Matcher hasFocus = HasFocusMatcher(hasFocus: true);
final Matcher hasNoFocus = HasFocusMatcher(hasFocus: false);
final Matcher hasNoSelection = HasSelectionMatcher(-1, -1);
Matcher hasSelection(int start, int end) => HasSelectionMatcher(start, end);
Matcher hasText(String text) => HasTextMatcher(text);
Matcher hasValue(double value) => HasValueMatcher(value);

class HasFocusMatcher extends CustomMatcher {
  HasFocusMatcher({bool hasFocus})
      : super('CupertinoTextField has focus', 'focus', equals(hasFocus));
  @override
  Object featureValueOf(covariant Finder finder) =>
      finder.textField.focusNode.hasFocus;
}

class HasSelectionMatcher extends CustomMatcher {
  HasSelectionMatcher(int start, int end)
      : super('CupertinoTextField has selection', 'selection',
            equals(TextRange(start: start, end: end)));
  @override
  Object featureValueOf(covariant Finder finder) =>
      finder.textField.controller.selection;
}

class HasTextMatcher extends CustomMatcher {
  HasTextMatcher(String text)
      : super('CupertinoTextField has text', 'text', equals(text));
  @override
  Object featureValueOf(covariant Finder finder) =>
      finder.textField.controller.text;
}

class HasValueMatcher extends CustomMatcher {
  HasValueMatcher(double value)
      : super('CupertinoSpinBox has value', 'value', equals(value));
  @override
  Object featureValueOf(dynamic state) => state.value;
}
