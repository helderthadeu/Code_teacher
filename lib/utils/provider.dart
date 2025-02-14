import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'detalhesFase.dart';

class DetalhesFase {
  late final String nome;
  late final int codFase;
  late final List<String> padraoMovimento;
  late final dica;

  DetalhesFase(int cod) {
    this.codFase = cod;
    this.padraoMovimento = padroesMovimentos()[codFase]!;
    this.dica = dicas()[codFase];
  }
}

class ControleRobo with ChangeNotifier {
  late DetalhesFase fase;
  List<BluetoothService> services = [];
  BluetoothCharacteristic? characteristicToSend;
  BluetoothCharacteristic? characteristicToReceive;
  BluetoothBondState previousBondState = BluetoothBondState.none;
  bool scanDisconect = false;
  final BluetoothDevice robo1 = BluetoothDevice.fromId("E4:65:B8:DA:22:FA");

  void setFase(int cod) {
    fase = DetalhesFase(cod);
    notifyListeners();
  }

  Future writeText(String indicador, String text, BuildContext context) async {
    try {
      await characteristicToSend?.write(indicador.codeUnits + text.codeUnits);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao enviar texto!')),
      );
      throw e;
    }
    print("Data enviado ${text.codeUnits}");
  }

  Future writeListText(String indicador, List<String> text, String caracterSep,
      BuildContext context) async {
    text.insert(0, indicador);
    String code = text.join(caracterSep).toString();

    try {
      await characteristicToSend?.write(code.codeUnits);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao enviar texto!')),
      );
      throw e;
    }
    print("Data enviado ${code.codeUnits}");
  }

  Future getServices(BuildContext context) async {
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
          characteristicToSend = c;
          // break;
        }
        if (c.uuid.toString() == "c14b6701-76a3-454a-9dcf-80902b406cba") {
          characteristicToReceive = c;
          await characteristicToReceive!.setNotifyValue(true);

          print("Encontrou o que recebe");

          characteristicToReceive!.onValueReceived.listen((data) {
            print(String.fromCharCodes(data));
            receivedMessage(String.fromCharCodes(data), context);
          });

          // break;
        }
      }
    }

    if (characteristicToSend == null) {
      print("Erro: Characteristic não encontrada.");
    }
    notifyListeners();
  }

  Future<void> connectBluetooth(BuildContext context) async {
    try {
      await robo1.connect(timeout: const Duration(seconds: 5)).whenComplete(() {
        print("Conectado");
        scanDisconect = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao enviar texto!')),
      );
    }

    previousBondState = BluetoothBondState.bonded;
    await getServices(context);
    notifyListeners();
  }

  receivedMessage(String message, BuildContext context) {
    if (message == "Robos encontrados") {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Robos encontrados"),
        );
      },);
    }
  }
}
