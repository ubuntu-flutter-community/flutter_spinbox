import 'package:flutter/cupertino.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(CupertinoSpinBox spinBox) {
  return CupertinoApp(home: CupertinoPageScaffold(child: spinBox));
}

void main() {
  testWidgets('hidden spin buttons omit prefix and suffix placeholders',
      (tester) async {
    await tester.pumpWidget(_app(CupertinoSpinBox(showButtons: false)));

    final field = tester.widget<CupertinoTextField>(
      find.byType(CupertinoTextField),
    );
    expect(field.prefix, isNull);
    expect(field.suffix, isNull);
    expect(find.byType(CupertinoButton), findsNothing);
  });

  testWidgets('vertical spin buttons omit horizontal placeholders',
      (tester) async {
    await tester.pumpWidget(
      _app(CupertinoSpinBox(direction: Axis.vertical)),
    );

    final field = tester.widget<CupertinoTextField>(
      find.byType(CupertinoTextField),
    );
    expect(field.prefix, isNull);
    expect(field.suffix, isNull);
    expect(find.byType(CupertinoButton), findsNWidgets(2));
  });

  testWidgets('custom prefix and suffix survive without buttons',
      (tester) async {
    await tester.pumpWidget(
      _app(CupertinoSpinBox(
        showButtons: false,
        prefix: const Text('prefix'),
        suffix: const Text('suffix'),
      )),
    );

    expect(find.text('prefix'), findsOneWidget);
    expect(find.text('suffix'), findsOneWidget);
    final field = tester.widget<CupertinoTextField>(
      find.byType(CupertinoTextField),
    );
    expect(field.prefix, isA<Text>());
    expect(field.suffix, isA<Text>());
  });

  testWidgets('horizontal buttons reserve space for custom adornments',
      (tester) async {
    await tester.pumpWidget(
      _app(CupertinoSpinBox(
        prefix: const Text('before'),
        suffix: const Text('after'),
      )),
    );

    final field = tester.widget<CupertinoTextField>(
      find.byType(CupertinoTextField),
    );
    expect(field.prefix, isA<Row>());
    expect(field.suffix, isA<Row>());
    expect(find.text('before'), findsOneWidget);
    expect(find.text('after'), findsOneWidget);
  });
}
