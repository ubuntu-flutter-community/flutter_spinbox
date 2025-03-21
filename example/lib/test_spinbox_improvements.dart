import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpinBox Improvements Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SpinBox Improvements Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _integerValue = 5;
  double _decimalValue = 5.5;
  double _manyDecimalsValue = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SpinBox with integer values (decimals: 0):'),
            SpinBox(
              min: 0,
              max: 10,
              value: _integerValue,
              decimals: 0,
              onChanged: (value) => setState(() => _integerValue = value),
            ),
            const SizedBox(height: 20),
            const Text('SpinBox with decimal values (decimals: 2):'),
            SpinBox(
              min: 0,
              max: 10,
              value: _decimalValue,
              decimals: 2,
              step: 0.5,
              onChanged: (value) => setState(() => _decimalValue = value),
            ),
            const SizedBox(height: 20),
            const Text('SpinBox with many decimals (decimals: 4):'),
            SpinBox(
              min: 0,
              max: 10,
              value: _manyDecimalsValue,
              decimals: 4,
              step: 0.1,
              onChanged: (value) => setState(() => _manyDecimalsValue = value),
            ),
            const SizedBox(height: 20),
            Text('Current values:'),
            Text('Integer: $_integerValue'),
            Text('Decimal: $_decimalValue'),
            Text('Many decimals: $_manyDecimalsValue'),
          ],
        ),
      ),
    );
  }
}
