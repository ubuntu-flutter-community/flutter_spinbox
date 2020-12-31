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

import '../spin_gesture.dart';

// ignore_for_file: public_member_api_docs

const double kSpinPadding = 16;

class CupertinoSpinButton extends StatelessWidget {
  const CupertinoSpinButton({
    Key? key,
    required this.icon,
    this.color,
    this.enabled = true,
    required this.step,
    this.acceleration,
    required this.interval,
    required this.onStep,
  }) : super(key: key);

  final Icon icon;
  final Color? color;
  final bool enabled;
  final double step;
  final double? acceleration;
  final Duration interval;
  final SpinCallback onStep;

  @override
  Widget build(BuildContext context) {
    return SpinGesture(
      enabled: enabled,
      step: step,
      interval: interval,
      acceleration: acceleration,
      onStep: onStep,
      child: CupertinoButton(
        color: color,
        padding: const EdgeInsets.all(kSpinPadding),
        onPressed: enabled ? () => onStep(step) : null,
        child: icon,
      ),
    );
  }
}
