import 'package:teste_ic/commons.dart';

class ControleRobo with ChangeNotifier {
  late LevelDetails level;
  List<BluetoothService> services = [];
  BluetoothCharacteristic? characteristicToSend;
  BluetoothCharacteristic? characteristicToReceive;
  BluetoothBondState previousBondState = BluetoothBondState.none;
  bool scanDisconect = false;
  final BluetoothDevice robo1 = BluetoothDevice.fromId("E4:65:B8:DA:22:FA");

  void setLevel(int cod) {
    level = LevelDetails(cod);
    notifyListeners();
  }

  Future writeText(String indicador, String text, BuildContext context) async {
    try {
      await characteristicToSend?.write(indicador.codeUnits + text.codeUnits);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Send text failed!')),
      );
      throw e;
    }
  }

  Future writeListText(String indicador, List<String> text, String caracterSep, BuildContext context) async {
    text.insert(0, indicador);
    String code = text.join(caracterSep).toString();

    try {
      await characteristicToSend?.write(code.codeUnits);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Send text failed!')),
      );
      throw e;
    }

  }

  Future getServices(BuildContext context) async {
    try {
      await robo1.clearGattCache();
      services = await robo1.discoverServices(timeout: 5000);
    } catch (e) {
      print("Error: " + e.toString());
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



          characteristicToReceive!.onValueReceived.listen((data) {
            print(String.fromCharCodes(data));
            receivedMessage(String.fromCharCodes(data), context);
          });

          // break;
        }
      }
    }

    if (characteristicToSend == null) {
      print("Error: Characteristic did not found.");
    }
    notifyListeners();
  }

  Future<void> connectBluetooth(BuildContext context) async {
    try {
      await robo1.connect(timeout: const Duration(seconds: 5)).whenComplete(() {

        scanDisconect = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Send text failed!')),
      );
    }

    previousBondState = BluetoothBondState.bonded;
    await getServices(context);
    notifyListeners();
  }

  receivedMessage(String message, BuildContext context) {
    if (message == "Robot found") {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Robot found!"),
          );
        },
      );
    }
  }
}
