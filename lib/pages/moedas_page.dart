import 'package:cripto_moedas/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';

class MoedasPage extends StatelessWidget {
  final tabela = MoedaRepository.tabela;

  MoedasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cripo Moedas'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int moeda) {
          return ListTile(
            leading: Image.asset(tabela[moeda].icone),
            title: Text(tabela[moeda].nome),
            trailing: Text(tabela[moeda].preco.toString()),
          );
        },
        padding: EdgeInsets.all(16),
        separatorBuilder: (_, ___) => Divider(),
        itemCount: tabela.length,
      ),
    );
  }
}
