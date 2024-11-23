<<<<<<< HEAD
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DetalhesFase {
  String nome;
  String objetivo;
  int codFase;

  DetalhesFase(
      {required this.nome, required this.objetivo, required this.codFase});

  // Future Jsonteste() {
  //
  //   // return "titulo": "conteudo",
  //
  // }
  static DetalhesFase fromJson(json) => DetalhesFase(
      nome: json['name'], objetivo: json['subtittle'], codFase: json['nFase']);
}

List<DetalhesFase> getEsp() {
  const data = [
    {"nome": "Fase 1", "decricao": "teste1", "nFase": 1},
    {"nome": "Fase 2", "decricao": "teste2", "nFase": 2},
    {"nome": "Fase 3", "decricao": "teste3", "nFase": 3},
  ];
  return data.map<DetalhesFase>(DetalhesFase.fromJson).toList();
}

class ControleRobo with ChangeNotifier {
  List<BluetoothService> services = [];
  BluetoothCharacteristic? characteristic;
  bool scanDisconect = false;
  late BluetoothDevice robo1 = BluetoothDevice.fromId("E4:65:B8:DA:22:FA");

  final BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  Future writeText(String text) async {
      await characteristic?.write(text.codeUnits);


    print("Data enviado ${text.codeUnits}");
  }

  Future getServices() async {
    try {
      await robo1.clearGattCache();
      services = await robo1.discoverServices(timeout: 5000);
    } catch (e) {
      print("Erro encontrado: " + e.toString());
    }
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.uuid.toString() == "6a1981ae-6033-456a-88a9-a0d6b3eab72f") {
          // UUID correto
          characteristic = c;
          break;
        }
      }
    }

    if (characteristic == null) {
      print("Erro: Characteristic não encontrada.");
    }
  }

  Future<void> connectBluetooth() async {
    await robo1.connect().whenComplete(() {
      print("Conectado");
      scanDisconect = true;

    });
    await getServices();


  }
}
=======
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DetalhesFase {
  String nome;
  String objetivo;
  int codFase;

  DetalhesFase(
      {required this.nome, required this.objetivo, required this.codFase});

  // Future Jsonteste() {
  //
  //   // return "titulo": "conteudo",
  //
  // }
  static DetalhesFase fromJson(json) => DetalhesFase(
      nome: json['name'], objetivo: json['subtittle'], codFase: json['nFase']);
}

List<DetalhesFase> getEsp() {
  const data = [
    {"nome": "Fase 1", "decricao": "teste1", "nFase": 1},
    {"nome": "Fase 2", "decricao": "teste2", "nFase": 2},
    {"nome": "Fase 3", "decricao": "teste3", "nFase": 3},
  ];
  return data.map<DetalhesFase>(DetalhesFase.fromJson).toList();
}

class ControleRobo with ChangeNotifier {
  List<BluetoothService> services = [];
  BluetoothCharacteristic? characteristic;
  late BluetoothDevice robo1 = BluetoothDevice.fromId("E4:65:B8:DA:22:FA");

  final BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  Future writeText(String text) async {
    await characteristic?.write(text.codeUnits);
    print("Data enviado ${text.codeUnits}");
  }

  Future getServices() async {
    try {
      await robo1.clearGattCache();
      services = await robo1.discoverServices(timeout: 5000);
    } catch (e) {
      print("Erro encontrado: " + e.toString());
    }
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.uuid.toString() == "6a1981ae-6033-456a-88a9-a0d6b3eab72f") {
          // UUID correto
          characteristic = c;
          break;
        }
      }
    }

    if (characteristic == null) {
      print("Erro: Characteristic não encontrada.");
    }
  }

  Future<void> connectBluetooth() async {
    await robo1.connect().whenComplete(() {
      print("Conectado");
    });
    await getServices();
  }
}
>>>>>>> 2c51d7e706cdd9c7d057bcef8ef1e7503d1625c5
