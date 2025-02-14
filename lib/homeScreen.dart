import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:teste_ic/utils/provider.dart';

import 'dart:convert';
import 'dart:typed_data';

// Endereço MAC de TESTE E4:65:B8:DA:22:FA
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BluetoothDevice controlRobotHome;

  @override
  void didChangeDependencies() async{
    controlRobotHome = context.watch<ControleRobo>().robo1;
    super.didChangeDependencies();
  }

  Widget botaoContinuar() {
    if (controlRobotHome.isConnected) {
      return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, "/fases");
        },
        child: const Text('Continuar'),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    // controleRobo = Provider.of<ControleRobo>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.read<ControleRobo>().connectBluetooth(context);

              },
              child: const Text('Sincronizar robôs'),
            ),
            botaoContinuar()
          ],
        ),
      ),
    );
  }
}
