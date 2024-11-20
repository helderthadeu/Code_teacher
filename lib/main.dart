import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teste_ic/controlScreen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:teste_ic/provider.dart';

import 'homeScreen.dart';
import 'levelsScreen.dart';

void main() {

  runApp(
    ChangeNotifierProvider(
      create: (_) => ControleRobo(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Aplicativo IC'),
      // home: const ControlPage(faseAtual: 0),
      routes: {
        // "/": (context) => const MyHomePage(title: "Tela inicial"),
        "/fases": (context) => const ScreenPage(),
        "/controles": (context) => const ControlPage(faseAtual: 0)
        },
      title: 'Aplicativo IC',
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  Future _requestBluetoothPermission() async {
    if (await Permission.bluetooth.isDenied ||
        await Permission.bluetoothConnect.isDenied ||
        await Permission.bluetoothScan.isDenied) {
      await [
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan
      ].request();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
      if (state != BluetoothAdapterState.on) {
        // navigator?.pop();
        _requestBluetoothPermission();
        FlutterBluePlus.turnOn();
      }
    });
  }
}


