
import 'package:teste_ic/commons.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key, required this.faseAtual});

  final int faseAtual;

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final int tamCode = 24;
List<Mnemonico> code = List<Mnemonico>.generate(24, (index) => Mnemonico("none", "none"), growable: true);

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _draggedContainers =  (List.generate(24, (index) => buildContainer(Colors.white, Icons.circle_outlined, "none")));

  List<Widget> _subDraggeds = List.generate(24, (index) => buildContainer(Colors.black12, Icons.add, "none"));

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (tes, te) async {
        await Future.delayed(const Duration(milliseconds: 100));
        Navigator.pushNamed(context, "/levels");
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            "Level ${widget.faseAtual}",
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
                          return Column(
                            children: [
                              DragTarget<Widget>(
                                builder: (context, candidateData, rejectedData) {
                                  return Container(
                                      width: 50, height: 50, color: Colors.grey[300], child: _draggedContainers[index]);
                                },
                                onWillAcceptWithDetails: (DragTargetDetails<Widget> details) {
                                  // return true;
                                  String temp =
                                      details.data.key.toString().toString().replaceAll("[<'", "").replaceAll("'>]", "");

                                  if ((temp == "xTwo" || temp == "xThree") && code[index].getComando() == "none") {
                                    return false;
                                  }
                                  if (index == 0) {
                                    return true;
                                  } else if (code[index - 1].getComando() != "none") {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                },
                                onAcceptWithDetails: (DragTargetDetails<Widget> details) {
                                  _draggedContainers[index] = details.data;
                                  code
                                      .elementAt(index)
                                      .setComando(details.data.key.toString().replaceAll("[<'", "").replaceAll("'>]", ""));
                                },
                              ),
                              DragTarget<Widget>(
                                builder: (context, candidateData, rejectedData) {


                                  return Container(width: 50, height: 50, color: Colors.grey[300], child: _subDraggeds[index]);
                                },
                                onWillAcceptWithDetails: (DragTargetDetails<Widget> details) {
                                  String temp =
                                      details.data.key.toString().toString().replaceAll("[<'", "").replaceAll("'>]", "");
                                  String tempPrev = _draggedContainers[index]
                                      .key
                                      .toString()
                                      .toString()
                                      .replaceAll("[<'", "")
                                      .replaceAll("'>]", "");

                                  if (tempPrev == "none") {
                                    return false;
                                  }
                                  if (temp == "xTwo" || temp == "xThree") {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                },
                                onAcceptWithDetails: (DragTargetDetails<Widget> details) {
                                  String temp =
                                      details.data.key.toString().toString().replaceAll("[<'", "").replaceAll("'>]", "");
                                  code.elementAt(index).setMultiplicador(temp);
                                  _subDraggeds[index] = details.data;
                                },
                              )
                            ],
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
                      buildDraggable(Colors.green, Icons.arrow_upward_rounded, 1, "ahead", true),
                      buildDraggable(Colors.green, Icons.arrow_forward_rounded, 2, "right", true),
                      buildDraggable(Colors.green, Icons.arrow_back_rounded, 3, "left", true),
                      buildDraggable(Colors.green, Icons.arrow_downward_rounded, 4, "back", true),
                      buildDraggable(Colors.blue, Icons.two_k_outlined, 6, "xTwo", false),
                      buildDraggable(Colors.blue, Icons.three_k_outlined, 7, "xThree", false),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      List<String> temp = [];
                      code.forEach((e) {
                        if (!e.getFullCommand().startsWith("none")) {
                          temp.add(e.getFullCommand());
                        }
                      });
                      context.read<ControleRobo>().writeListText("commands", temp, "@", context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code compile successfully!')),
                      );

                      Future.delayed(const Duration(seconds: 2));
                      await context.read<ControleRobo>().writeText("start", "", context);
                    },
                    child: const Text(
                      "Compile",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  IconButton(onPressed: () {
                    _draggedContainers.clear();
                    _subDraggeds.clear();
                    code.clear();
                    _draggedContainers =  (List.generate(24, (index) => buildContainer(Colors.white, Icons.circle_outlined, "none")));
                    _subDraggeds = List.generate(24, (index) => buildContainer(Colors.black12, Icons.add, "none"));
                    code = List<Mnemonico>.generate(24, (index) => Mnemonico("none", "none"), growable: true);
                    setState(() {

                    });
                  }, icon: const Icon(Icons.clear,size: 30,))
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}

Widget buildDraggable(Color color, IconData icon, int codigo, String comando, bool setas) {
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
