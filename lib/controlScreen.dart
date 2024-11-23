import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_ic/provider.dart';

import 'utils/extra.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key, required this.faseAtual});

  final int faseAtual;

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  late final ControleRobo controleRobo;

  @override
  void didChangeDependencies() {
    controleRobo = Provider.of<ControleRobo>(context);
    super.didChangeDependencies();
  }

  final int tamCode = 24;
  List<Mnemonico> code = List<Mnemonico>.generate(
      24, (index) => Mnemonico("nada", "nada"),
      growable: true);

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _draggedContainers = (List.generate(24,
      (index) => buildContainer(Colors.white, Icons.circle_outlined, "nada")));

  final List<DragTarget<Widget>> _subDraggeds = List.generate(
      24,
      (index) => DragTarget(
            builder: (context, candidateData, rejectedData) {
              Widget internoTemp =
                  buildContainer(Colors.black12, Icons.add, "Teste");

              return Container(
                padding: EdgeInsets.zero,
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: internoTemp,
              );
            },
            onWillAcceptWithDetails: (DragTargetDetails<Widget> details) {
              return true;
              // String temp = details.data.key
              //     .toString()
              //     .toString()
              //     .replaceAll("[<'", "")
              //     .replaceAll("'>]", "");
              //
              // if (temp == "xUm" || temp == "xDois" || temp == "xTres") {
              //   return true;
              // } else {
              //   return false;
              // }
            },
            onAcceptWithDetails: (DragTargetDetails<Widget> details) {
              //
              //

              // print(details.data.key);
            },
          ));

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (tes, te) async {
        await Future.delayed(const Duration(milliseconds: 100));
        Navigator.pushNamed(context, "/fases");
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            "FASE ATUAL: ${widget.faseAtual}",
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                      alignment: Alignment.center,
                      // color: Colors.white,
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 1.0,
                        children: List.generate(tamCode, (index) {
                          return DragTarget<Widget>(
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                  width: 50,
                                  height: 125,
                                  color: Colors.grey[300],
                                  child: Column(children: [
                                    _draggedContainers[index],
                                    _subDraggeds[index]
                                  ]));
                            },
                            onWillAcceptWithDetails:
                                (DragTargetDetails<Widget> details) {
                              // return true;
                              String temp = details.data.key
                                  .toString()
                                  .toString()
                                  .replaceAll("[<'", "")
                                  .replaceAll("'>]", "");

                              if ((temp == "xUm" ||
                                      temp == "xDois" ||
                                      temp == "xTres") &&
                                  code[index].getComando() == "nada") {
                                return false;
                              } else {
                                if (index == 0) {
                                  return true;
                                } else if (code[index - 1].getComando() !=
                                    "nada") {
                                  return true;
                                } else {
                                  return false;
                                }
                              }
                            },
                            onAcceptWithDetails:
                                (DragTargetDetails<Widget> details) {
                              String temp = details.data.key
                                  .toString()
                                  .toString()
                                  .replaceAll("[<'", "")
                                  .replaceAll("'>]", "");
                              if ((temp == "xUm" ||
                                  temp == "xDois" ||
                                  temp == "xTres")) {
                                // _subDraggeds[index] = details.data;
                                code.elementAt(index).setMultiplicador(temp);
                                _subDraggeds[index] = DragTarget(
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    Widget interno = buildContainer(
                                        Colors.black12, Icons.add, "Teste");

                                    return details.data;
                                  },
                                  onWillAcceptWithDetails:
                                      (DragTargetDetails<Widget> details) {
                                    print(details.data);
                                    return true;
                                  },
                                  onAcceptWithDetails:
                                      (DragTargetDetails<Widget> teste) {},
                                );
                              } else {
                                _draggedContainers[index] = details.data;
                              }
                              code.elementAt(index).setComando(details.data.key
                                  .toString()
                                  .replaceAll("[<'", "")
                                  .replaceAll("'>]", ""));
                            },
                          );
                        }),
                      ))),
              Padding(
                padding: const EdgeInsets.all(11),
                child: Container(
                  color: Colors.white,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 20.0,
                    direction: Axis.horizontal,
                    children: [
                      buildDraggable(Colors.green, Icons.arrow_upward_rounded,
                          1, "frente", true),
                      buildDraggable(Colors.green, Icons.arrow_forward_rounded,
                          2, "direita", true),
                      buildDraggable(Colors.green, Icons.arrow_back_rounded, 3,
                          "esquerda", true),
                      buildDraggable(Colors.green, Icons.arrow_downward_rounded,
                          4, "tras", true),
                      buildDraggable(
                          Colors.blue, Icons.one_k_outlined, 5, "xUm", false),
                      buildDraggable(
                          Colors.blue, Icons.two_k_outlined, 6, "xDois", false),
                      buildDraggable(Colors.blue, Icons.three_k_outlined, 7,
                          "xTres", false),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  try {
                    for (int i = 0; i < code.length; i++) {
                      controleRobo.writeText(
                          "${code[i].getComando()}:${code[i].getMultiplicador()}");
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código enviado sucesso!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Falha ao enviar os dados!')),
                    );
                  }
                },
                child: const Text(
                  "Compilar",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

Widget buildDraggable(
    Color color, IconData icon, int codigo, String comando, bool setas) {
  Widget container = buildContainer(color, icon, comando);
  return Draggable<Widget>(
      key: ValueKey(codigo),
      data: container,
      feedback: Column(
        children: [container],
        // children: [_container, (setas) ? _buildSetas() : const Text("")],
      ),
      child: Column(
        children: [container],
        // children: [_container, (setas) ? _buildSetas() : const Text("")],
      ));
}

// Widget _buildSetas() {
//   Widget interno = buildContainer(Colors.black12, Icons.add, "Teste");
//   return DragTarget<Widget>(
//     builder: (context, candidateData, rejectedData) {
//       return Container(
//         padding: EdgeInsets.zero,
//         width: 50,
//         height: 50,
//         color: Colors.grey[300],
//         child: interno,
//       );
//     },
//     onWillAcceptWithDetails: (DragTargetDetails<Widget> details) {
//       String temp = details.data.key
//           .toString()
//           .toString()
//           .replaceAll("[<'", "")
//           .replaceAll("'>]", "");
//
//       if (temp == "xUm" || temp == "xDois" || temp == "xTres") {
//         return true;
//       } else {
//         return false;
//       }
//     },
//     onAcceptWithDetails: (DragTargetDetails<Widget> details) {
//       interno = details.data;
//     },
//   );
// }

Widget buildContainer(Color color, IconData icon, String comando) {
  return Container(
    key: Key(comando),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Colors.white), // Exibe o ícone
        const SizedBox(height: 4),
      ],
    ),
  );
}
