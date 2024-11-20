import 'package:flutter/material.dart';

class DragTargetEspecial {
  DragTargetEspecial(){
    temp = _buildSetasInterno();
  }

  final DragTargetDetails<Widget> _details = DragTargetDetails(data: Container(), offset: const Offset(0, 0));
  late Widget temp;

  Widget _buildSetasInterno() {
    Widget interno = buildContainer(Colors.black12, Icons.add, "Teste");
    return DragTarget<Widget>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: EdgeInsets.zero,
          width: 50,
          height: 50,
          color: Colors.grey[300],
          child: interno,
        );
      },
      onWillAcceptWithDetails: (DragTargetDetails<Widget> details) {
        String temp = _details.data.key
            .toString()
            .toString()
            .replaceAll("[<'", "")
            .replaceAll("'>]", "");

        if (temp == "xUm" || temp == "xDois" || temp == "xTres") {
          return true;
        } else {
          return false;
        }
      },
      onAcceptWithDetails: (DragTargetDetails<Widget> details) {
        interno = _details.data;
      },
    );
  }



}

Widget buildDraggable(Color color, IconData icon, int codigo, String comando,
    bool setas) {
  Widget container = buildContainer(color, icon, comando);
  return Draggable<Widget>(
      key: ValueKey(codigo),
      data: container,
      feedback: Column(
        children: [container, (setas) ? _buildSetas() : const Text("")],
      ),
      child: Column(
        children: [container, (setas) ? _buildSetas() : const Text("")],
      ));
}
//
Widget _buildSetas() {
  Widget interno = buildContainer(Colors.black12, Icons.add, "Teste");
  return DragTarget<Widget>(
    builder: (context, candidateData, rejectedData) {
      return Container(
        padding: EdgeInsets.zero,
        width: 50,
        height: 50,
        color: Colors.grey[300],
        child: interno,
      );
    },
    onWillAcceptWithDetails: (DragTargetDetails<Widget> details) {
      String temp = details.data.key
          .toString()
          .toString()
          .replaceAll("[<'", "")
          .replaceAll("'>]", "");

      if (temp == "xUm" || temp == "xDois" || temp == "xTres") {
        return true;
      } else {
        return false;
      }
    },
    onAcceptWithDetails: (DragTargetDetails<Widget> details) {
      interno = details.data;
    },
  );
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
