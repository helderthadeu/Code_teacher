import 'package:teste_ic/commons.dart';

class LevelDetails {
  late final String name;
  late final int levelCode;
  late final List<String> padraoMovimento;
  late final dica;

  LevelDetails(int cod) {
    this.levelCode = cod;
    this.padraoMovimento = padroesMovimentos()[levelCode]!;
    this.dica = dicas()[levelCode];
  }
}


Map<int, List<String>> padroesMovimentos() {
  return {
    1: ["1",
      "atras", "atras",  "direita", "direita", "atras", "atras", "esquerda",
      "esquerda", "esquerda", "esquerda",  "direita", "frente", "frente",
      "direita", "frente", "frente"
    ],
    2: ["2", "frente", "esquerda", "atras", "direita"],
    3: ["3", "atras", "atras", "frente", "frente"]
  };
}

Map<int, String> dicas() {
  return {
    1: "Símbolo do infinito",
    2: "Exemplo de quadrilátero",
    3: "Vai e vem",
  };
}
