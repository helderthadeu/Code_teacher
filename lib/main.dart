import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teste_ic/controlScreen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:teste_ic/utils/provider.dart';
import 'package:teste_ic/utils/extra.dart';

import 'homeScreen.dart';
import 'levelsScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ControleRobo(),
      child: const MyApp(),
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
      navigatorObservers: [BluetoothAdapterStateObserver(context)],
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  late BluetoothDevice robotControl;
  late BuildContext thisContext;

  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  StreamSubscription<BluetoothConnectionState>? _controleState;

  BluetoothAdapterStateObserver(BuildContext context) {
    robotControl = context.watch<ControleRobo>().robo1;
    thisContext = context;
  }

  Future _requestBluetoothPermission() async {
    if (await Permission.bluetooth.isDenied ||
        await Permission.bluetoothConnect.isDenied ||
        await Permission.bluetoothScan.isDenied) {
      await [Permission.bluetooth, Permission.bluetoothConnect, Permission.bluetoothScan].request();
    }
  }

  void buildDisconnectAdivor(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Dispositivo desconectado",
            textAlign: TextAlign.left,
          ),
          content: const Text(
            "Aperte para reconectar",
            textAlign: TextAlign.start,
          ),
          actions: [
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<ControleRobo>().connectBluetooth(context).whenComplete(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dispositivo conectado com sucesso!')),
                    );
                    if (context.read<ControleRobo>().robo1.isConnected) {
                      Navigator.of(context).pop();
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Não foi possível conectar, tente novamente')),
                  );
                }
              },
              child: const Text("Conectar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off && route.navigator != null &&
          route.navigator!.mounted && !Navigator.canPop(route.navigator!.context)) {
        _requestBluetoothPermission();
        FlutterBluePlus.turnOn().whenComplete(() {
          (route.navigator!.context.read<ControleRobo>().previousBondState == BluetoothBondState.bonded)
              ? buildDisconnectAdivor(route.navigator!.context)
              : null;
        });
      }
    });

    _controleState ??= route.navigator!.context.read<ControleRobo>().robo1.connectionState.listen((data) {});

    _controleState?.onData((data) {
      print("Esperando..");
      if (data == BluetoothConnectionState.disconnected && route.navigator != null &&
          route.navigator!.mounted &&
          route.navigator!.context.read<ControleRobo>().previousBondState == BluetoothBondState.bonded &&
          !Navigator.canPop(route.navigator!.context)) {
        print("Robo 1 desconectado");
        buildDisconnectAdivor(route.navigator!.context);
      }
      Future.delayed(const Duration(seconds: 1));
    });
  }
}
