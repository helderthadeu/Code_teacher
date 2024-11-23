<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:teste_ic/controlScreen.dart';
import 'dart:async';
import 'provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
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
              // bottom: PreferredSize(
              //     preferredSize: const Size(20, 20),
              //     child: BackButton(
              //       onPressed: () async {
              //         await Future.delayed(const Duration(milliseconds: 100));
              //         Navigator.popAndPushNamed(context, "/");
              //       },
              //     )),
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
=======
import 'package:flutter/material.dart';
import 'package:teste_ic/controlScreen.dart';
import 'dart:async';
import 'provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
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
              // bottom: PreferredSize(
              //     preferredSize: const Size(20, 20),
              //     child: BackButton(
              //       onPressed: () async {
              //         await Future.delayed(const Duration(milliseconds: 100));
              //         Navigator.popAndPushNamed(context, "/");
              //       },
              //     )),
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
>>>>>>> 2c51d7e706cdd9c7d057bcef8ef1e7503d1625c5
