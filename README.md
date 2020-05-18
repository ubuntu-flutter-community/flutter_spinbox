# SpinBox for Flutter

[![pub](https://img.shields.io/pub/v/flutter_spinbox.svg)](https://pub.dev/packages/flutter_spinbox)
[![license: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![build](https://github.com/jpnurmi/flutter_spinbox/workflows/build/badge.svg)
[![codecov](https://codecov.io/gh/jpnurmi/flutter_spinbox/branch/master/graph/badge.svg)](https://codecov.io/gh/jpnurmi/flutter_spinbox)

SpinBox for [Flutter](https://flutter.dev) is a numeric input widget with an input field for
entering a specific value, and stepper buttons for quick, convenient, and accurate value adjustments. 

![SpinBox](https://raw.githubusercontent.com/jpnurmi/flutter_spinbox/master/doc/images/spinbox.gif "SpinBox")

SpinBox is best suited for such applications where users typically know upfront the exact value
they are entering, but may later have the need to accurately adjust a previously entered value.

## Usage

To use this package, add `flutter_spinbox` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```dart
import 'package:flutter_spinbox/flutter_spinbox.dart';

SpinBox(
  min: 1,
  max: 100,
  value: 50,
  onChanged: (value) => print(value),
)
```
