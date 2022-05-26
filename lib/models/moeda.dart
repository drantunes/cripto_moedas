class Moeda {
  String baseId;
  String icone;
  String nome;
  String sigla;
  double preco;
  DateTime timestamp;
  double mudancaHora;
  double mudancaDia;
  double mudancaSemana;
  double mudancaMes;
  double mudancaAno;
  double mudancaPeriodoTotal;

  Moeda({
    required this.baseId,
    required this.icone,
    required this.nome,
    required this.sigla,
    required this.preco,
    required this.timestamp,
    required this.mudancaHora,
    required this.mudancaDia,
    required this.mudancaSemana,
    required this.mudancaMes,
    required this.mudancaAno,
    required this.mudancaPeriodoTotal,
  });
}
