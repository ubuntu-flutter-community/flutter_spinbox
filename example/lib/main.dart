import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('SpinBox for Flutter'),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.swap_horiz)),
                  Tab(icon: Icon(Icons.swap_vert)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                HorizontalSpinBoxPage(),
                VerticalSpinBoxPage(),
              ],
            ),
          ),
        ),
      ),
    );

class HorizontalSpinBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: [
          Padding(
            child: SpinBox(
              value: 10,
              decoration: InputDecoration(labelText: 'Basic'),
            ),
            padding: const EdgeInsets.all(16),
          ),
          Padding(
            child: SpinBox(
              value: 10,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Read-only'),
            ),
            padding: const EdgeInsets.all(16),
          ),
          Padding(
            child: SpinBox(
              value: 5,
              digits: 2,
              decoration: InputDecoration(labelText: '2 digits'),
            ),
            padding: const EdgeInsets.all(16),
          ),
          Padding(
            child: SpinBox(
              max: 10.0,
              value: 5.0,
              decimals: 1,
              step: 0.1,
              decoration: InputDecoration(labelText: 'Decimals'),
            ),
            padding: const EdgeInsets.all(16),
          ),
          Padding(
            child: SpinBox(
              min: -1.0,
              max: 1.0,
              value: 0.25,
              decimals: 3,
              step: 0.001,
              acceleration: 0.001,
              decoration: InputDecoration(labelText: 'Accelerated'),
            ),
            padding: const EdgeInsets.all(16),
          ),
          Padding(
            child: SpinBox(
              value: 50,
              decoration: InputDecoration(
                hintText: 'Hint',
                labelText: 'Decorated',
                helperText: 'Helper',
                prefix: const Text('Prefix'),
                suffix: const Text('Suffix'),
                counterText: 'Counter',
              ),
              validator: (text) => text!.isEmpty ? 'Invalid' : null,
            ),
            padding: const EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }
}

class VerticalSpinBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Container(
                width: 128,
                child: SpinBox(
                  min: -50,
                  max: 50,
                  value: 15,
                  spacing: 24,
                  direction: Axis.vertical,
                  textStyle: TextStyle(fontSize: 48),
                  incrementIcon: Icon(Icons.keyboard_arrow_up, size: 64),
                  decrementIcon: Icon(Icons.keyboard_arrow_down, size: 64),
                  iconColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    if (states.contains(MaterialState.error)) {
                      return Colors.red;
                    }
                    if (states.contains(MaterialState.focused)) {
                      return Colors.blue;
                    }
                    return Colors.black;
                  }),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
