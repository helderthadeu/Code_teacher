import 'package:teste_ic/commons.dart';

// Endereço MAC de TESTE E4:65:B8:DA:22:FA
class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key, required this.title});
  final String title;

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late BluetoothDevice controlRobotHome;

  @override
  void didChangeDependencies() async{
    controlRobotHome = context.watch<ControleRobo>().robo1;
    super.didChangeDependencies();
  }

  Widget startButton() {
    if (controlRobotHome.isConnected) {
      return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, "/levels");
        },
        child: const Text('Start'),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.read<ControleRobo>().connectBluetooth(context);
              },
              child: const Text('Synchronize robot'),
            ),
            startButton()
          ],
        ),
      ),
    );
  }
}
