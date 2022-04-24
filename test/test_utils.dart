import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension EditableTextFinders on CommonFinders {
  Finder get editableText => byType(EditableText);
}

extension EditableTextFinder on Finder {
  Widget get widget => evaluate().first.widget;
  EditableText get editableText => widget as EditableText;
  FocusNode get focusNode => editableText.focusNode;
}

final Matcher hasFocus = HasFocusMatcher(hasFocus: true);
final Matcher hasNoFocus = HasFocusMatcher(hasFocus: false);
final Matcher hasNoSelection = SelectionLengthMatcher(0);
Matcher hasSelection(int start, int end) => HasSelectionMatcher(start, end);
Matcher hasText(String text) => HasTextMatcher(text);
Matcher hasValue(double value) => HasValueMatcher(value);

class HasFocusMatcher extends CustomMatcher {
  HasFocusMatcher({required bool hasFocus})
      : super('EditableText has focus', 'focus', equals(hasFocus));
  @override
  Object featureValueOf(covariant Finder finder) =>
      finder.editableText.focusNode.hasFocus;
}

class SelectionLengthMatcher extends CustomMatcher {
  SelectionLengthMatcher(int length)
      : super('EditableText has selection', 'selection', equals(length));
  @override
  Object featureValueOf(covariant Finder finder) =>
      (finder.editableText.controller.selection.end -
              finder.editableText.controller.selection.start)
          .abs();
}

class HasSelectionMatcher extends CustomMatcher {
  HasSelectionMatcher(int start, int end)
      : super('EditableText has selection', 'selection',
            equals(TextRange(start: start, end: end)));
  @override
  Object featureValueOf(covariant Finder finder) =>
      finder.editableText.controller.selection;
}

class HasTextMatcher extends CustomMatcher {
  HasTextMatcher(String text)
      : super('EditableText has text', 'text', equals(text));
  @override
  Object featureValueOf(covariant Finder finder) =>
      finder.editableText.controller.text;
}

class HasValueMatcher extends CustomMatcher {
  HasValueMatcher(double value)
      : super('SpinBox has value', 'value', equals(value));
  @override
  // ### TODO: make BaseSpinBoxState a mixin?
  // ignore: avoid_dynamic_calls
  Object? featureValueOf(dynamic state) => state.value;
}
