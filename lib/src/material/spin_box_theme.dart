import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines default property values for descendant [SpinBox] widgets.
///
/// Descendant widgets obtain the current [SpinBoxThemeData] object using
/// `SpinBoxTheme.of(context)`. Instances of [SpinBoxThemeData] can be
/// customized with [SpinBoxThemeData.copyWith].
///
/// All [SpinBoxThemeData] properties are `null` by default. When null, the
/// [SpinBox] will provide its own defaults based on the overall [Theme]'s
/// colorScheme. See the individual [SpinBox] properties for details.
@immutable
class SpinBoxThemeData with Diagnosticable {
  /// Creates a theme that can be used for [SpinBoxTheme.data].
  const SpinBoxThemeData({this.iconColor});

  /// The color to use for [SpinBox.incrementIcon] and [SpinBox.decrementIcon].
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///  * [MaterialState.error].
  ///
  /// If specified, overrides the default value of [SpinBox.iconColor].
  final MaterialStateProperty<Color?>? iconColor;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  SpinBoxThemeData copyWith({MaterialStateProperty<Color?>? iconColor}) {
    return SpinBoxThemeData(iconColor: iconColor ?? this.iconColor);
  }

  @override
  int get hashCode => iconColor.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is SpinBoxThemeData && other.iconColor == iconColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'iconColor',
        iconColor,
        defaultValue: null,
      ),
    );
  }
}

/// Applies a theme to descendant [SpinBox] widgets.
///
/// Descendant widgets obtain the current [SpinBoxTheme] object using
/// [SpinBoxTheme.of]. When a widget uses [SpinBoxTheme.of], it is
/// automatically rebuilt if the theme later changes.
///
/// See also:
///
///  * [SpinBoxThemeData], which describes the actual configuration of a
///  spinbox theme.
class SpinBoxTheme extends InheritedWidget {
  /// Constructs a checkbox theme that configures all descendant [SpinBox]
  /// widgets.
  const SpinBoxTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The properties used for all descendant [SpinBox] widgets.
  final SpinBoxThemeData data;

  /// Returns the configuration [data] from the closest [SpinBoxTheme]
  /// ancestor. If there is no ancestor, it returns `null`.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// SpinBoxThemeData theme = SpinBoxTheme.of(context);
  /// ```
  static SpinBoxThemeData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SpinBoxTheme>()?.data;
  }

  @override
  bool updateShouldNotify(SpinBoxTheme oldWidget) => data != oldWidget.data;
}
