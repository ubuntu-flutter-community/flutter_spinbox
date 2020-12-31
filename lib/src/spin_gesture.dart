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

import 'dart:async';

import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs

typedef SpinCallback = bool Function(double value);

class SpinGesture extends StatefulWidget {
  const SpinGesture({
    Key? key,
    this.enabled = true,
    required this.child,
    required this.step,
    this.acceleration,
    required this.interval,
    required this.onStep,
  }) : super(key: key);

  final bool enabled;
  final Widget child;
  final double step;
  final double? acceleration;
  final Duration interval;
  final SpinCallback onStep;

  @override
  _SpinGestureState createState() => _SpinGestureState();
}

class _SpinGestureState extends State<SpinGesture> {
  Timer? timer;
  late double step;

  @override
  void initState() {
    super.initState();
    step = widget.step;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: widget.enabled ? (_) => startTimer() : null,
      onLongPressEnd: widget.enabled ? (_) => stopTimer() : null,
      child: widget.child,
    );
  }

  bool onStep() {
    if (!widget.enabled) return false;
    if (widget.acceleration != null) {
      step += widget.acceleration!;
    }
    return widget.onStep(step);
  }

  void startTimer() {
    if (timer != null) return;
    timer = Timer.periodic(widget.interval, (timer) {
      if (!onStep()) {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
    step = widget.step;
  }
}
