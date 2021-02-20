import 'dart:async';

import 'package:battery_app/main.dart';
import 'package:flutter/material.dart';
import 'package:battery/battery.dart';

class BatteryPage extends StatefulWidget {
  @override
  _BatteryPageState createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  final battery = Battery();
  int batterylevel = 100;
  BatteryState batteryState = BatteryState.full;

  Timer timer;
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    listenBatteryLevel();
    listenBatteryState();
  }

  void listenBatteryState() =>
      subscription = battery.onBatteryStateChanged.listen(
        (batteryState) => setState(() => this.batteryState = batteryState),
      );

  void listenBatteryLevel() {
    updateBatteryLevel();

    timer = Timer.periodic(
      Duration(seconds: 10),
      (_) async => updateBatteryLevel(),
    );
  }

  Future updateBatteryLevel() async {
    final batteryLevel = await battery.batteryLevel;

    setState(() => this.batterylevel = batterylevel);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBatteryState(batteryState),
              const SizedBox(height: 30),
              buildBatteryLevel(batterylevel),
            ],
          ),
        ),
      );

  Widget buildBatteryState(BatteryState batteryState) {
    final style = TextStyle(fontSize: 32, color: Colors.white);
    final double size = 300;

    switch (batteryState) {
      case BatteryState.full:
        final color = Colors.green;

        return Column(
          children: [
            Icon(
              Icons.battery_full,
              size: size,
              color: color,
            ),
            Text('Full', style: style.copyWith(color: color)),
          ],
        );
      case BatteryState.charging:
        final color = Colors.blue;

        return Column(
          children: [
            Icon(
              Icons.battery_charging_full,
              size: size,
              color: color,
            ),
            Text('Yo!!! I am Charging', style: style.copyWith(color: color)),
          ],
        );
      case BatteryState.discharging:
      default:
        final color = Colors.red;
        return Column(
          children: [
            Icon(
              Icons.battery_full,
              size: size,
              color: color,
            ),
            Text('Yo!! I am Discharging', style: style.copyWith(color: color)),
          ],
        );
    }
  }

  Widget buildBatteryLevel(int batteryLevel) => Text(
        '$batteryLevel%',
        style: TextStyle(
            fontSize: 46, color: Colors.black, fontWeight: FontWeight.bold),
      );
}
