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

/// {@template flutter_spinbox.SpinBox}
/// A numeric input widget with an input field for entering a specific value,
/// and spin buttons for quick, convenient, and accurate value adjustments.
/// {@endtemplate}
///
/// ## Guidelines
///
/// Spin boxes are best suited for such applications
/// - that deal with large numeric value ranges and high precisions,
/// - where users typically know upfront the exact value they are entering,
/// - where users may later have a need to accurately adjust a previously
///   entered value.
///
/// As a rule of thumb, spin boxes are great for scenarios where
/// - sliders and alike UI controls are too inaccurate,
/// - tumblers and alike UI controls cannot provide enough value range,
/// - and a plain text field is inconvenient for value adjustments
///  (open the VKB, move the cursor, erase the previous value, enter a new
///   value... vs. tap-tap-done).
///
/// ## Designs
///
/// SpinBox for Flutter comes in two variants. It provides implementations for
/// both designs in Flutter, Material and Cupertino (iOS).
library flutter_spinbox;

export 'cupertino.dart';
export 'material.dart';
