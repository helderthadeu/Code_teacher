import 'package:teste_ic/commons.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}


class _ScreenPageState extends State<ScreenPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (tes, te) async {
          await Future.delayed(const Duration(milliseconds: 100));
          Navigator.popAndPushNamed(context, "/");
        },
        child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Fases disponíveis: ",
                      style: TextStyle(fontSize: 40, decorationThickness: 200)),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(3, (index) {
                        return MaterialButton(
                          onPressed: () {
                            context.read<ControleRobo>().setLevel(index+1);

                            context.read<ControleRobo>().writeListText("currentPattern",context.read<ControleRobo>().level.padraoMovimento,"@",context).whenComplete((){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Fase carregada com sucesso!')),
                              );
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ControlPage(faseAtual: index+1)
                                )
                            );
                          },
                          padding: const EdgeInsets.all(8),
                          color: Colors.greenAccent,
                          height: 90,
                          child: Text("${index + 1}",
                              style: const TextStyle(
                                  fontSize: 25, decorationThickness: 200)),
                        );
                      }),
                    ),
                  )
                ],
              ),
            )));
  }
}
