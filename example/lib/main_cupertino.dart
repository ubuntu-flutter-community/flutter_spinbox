import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/cupertino.dart';

void main() => runApp(
      CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('CupertinoSpinBox for Flutter'),
          ),
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.ellipsis),
                  label: 'Horizontal',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.ellipsis),
                  label: 'Vertical',
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) => index == 0 ? HorizontalSpinBoxPage() : VerticalSpinBoxPage(),
          ),
        ),
      ),
    );

class HorizontalSpinBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final caption = TextStyle(fontWeight: FontWeight.bold);
    return CupertinoScrollbar(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: Text('Basic', style: caption),
                  padding: const EdgeInsets.only(left: 16, top: 12),
                ),
                CupertinoSpinBox(
                  value: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: Text('Im readOnly spinbox (change only with buttons)', style: caption),
                  padding: const EdgeInsets.only(left: 16, top: 12),
                ),
                CupertinoSpinBox(
                  value: 10,
                  readOnly: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: Text('Decimals', style: caption),
                  padding: const EdgeInsets.only(left: 16),
                ),
                CupertinoSpinBox(
                  max: 10.0,
                  value: 5.0,
                  decimals: 1,
                  step: 0.1,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: Text('Accelerated', style: caption),
                  padding: const EdgeInsets.only(left: 16),
                ),
                CupertinoSpinBox(
                  min: -1.0,
                  max: 1.0,
                  value: 0.25,
                  decimals: 3,
                  step: 0.001,
                  acceleration: 0.001,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                child: Text('Decorated', style: caption),
                padding: const EdgeInsets.only(left: 16, top: 16),
              ),
              CupertinoSpinBox(
                value: 50,
                prefix: Text('prefix'),
                suffix: Text('suffix'),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide(
                      width: 0,
                      color: CupertinoColors.inactiveGray,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VerticalSpinBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Container(
                width: 128,
                child: CupertinoSpinBox(
                  min: -50,
                  max: 50,
                  value: 15,
                  spacing: 24,
                  direction: Axis.vertical,
                  textStyle: TextStyle(fontSize: 48),
                  incrementIcon: Icon(CupertinoIcons.up_arrow, size: 64),
                  decrementIcon: Icon(CupertinoIcons.down_arrow, size: 64),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: CupertinoDynamicColor.withBrightness(
                      color: CupertinoColors.white,
                      darkColor: CupertinoColors.black,
                    ),
                    border: Border.all(
                      color: CupertinoDynamicColor.withBrightness(
                        color: Color(0x33000000),
                        darkColor: Color(0x33FFFFFF),
                      ),
                      style: BorderStyle.solid,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
