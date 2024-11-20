import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:teste_ic/provider.dart';

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
  // final controleRobo.getRobo1() = BluetoothDevice.fromId("E4:65:B8:DA:22:FA");
  late final ControleRobo controleRobo;

  @override
  void didChangeDependencies() {
    controleRobo = Provider.of<ControleRobo>(context);
    super.didChangeDependencies();
  }

  Widget botaoContinuar() {
    if (controleRobo.robo1.isConnected) {
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                controleRobo.connectBluetooth();
                  Future.delayed(const Duration(milliseconds: 500)).whenComplete((){
                    setState(() {

                    });
                  // setState(() {});
                  // setState(() {});
                });
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
