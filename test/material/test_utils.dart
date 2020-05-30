import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_test/flutter_test.dart';

class TestApp extends MaterialApp {
  TestApp({Widget widget}) : super(home: Scaffold(body: widget));
}

extension SpinBoxFinders on CommonFinders {
  Finder get spinBox => byType(SpinBox);
  Finder get textField => byType(TextField);
  Finder get increment => byIcon(Icons.add);
  Finder get decrement => byIcon(Icons.remove);
}

extension SpinBoxFinder on Finder {
  Widget get widget => evaluate().first.widget;
  TextField get textField => widget as TextField;
  SpinBox get spinBox => widget as SpinBox;
}

final Matcher hasFocus = HasFocusMatcher(true);
final Matcher hasNoFocus = HasFocusMatcher(false);
final Matcher hasNoSelection = HasSelectionMatcher(-1, -1);
Matcher hasSelection(int start, int end) => HasSelectionMatcher(start, end);
Matcher hasValue(double value) => HasValueMatcher(value);

class HasFocusMatcher extends CustomMatcher {
  HasFocusMatcher(bool hasFocus)
      : super('TextField has focus', 'focus', equals(hasFocus));
  @override
  Object featureValueOf(covariant Finder finder) =>
      finder.textField.focusNode.hasFocus;
}

class HasSelectionMatcher extends CustomMatcher {
  HasSelectionMatcher(int start, int end)
      : super('TextField has selection', 'selection',
            equals(TextRange(start: start, end: end)));
  @override
  Object featureValueOf(covariant Finder finder) =>
      finder.textField.controller.selection;
}

class HasValueMatcher extends CustomMatcher {
  HasValueMatcher(double value)
      : super('SpinBox has value', 'value', equals(value));
  @override
  Object featureValueOf(dynamic state) => state.value;
}
