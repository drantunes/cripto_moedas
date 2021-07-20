import 'package:cripto_moedas/configs/app_settings.dart';
import 'package:cripto_moedas/models/moeda.dart';
import 'package:cripto_moedas/pages/moedas_detalhes_page.dart';
import 'package:cripto_moedas/repositories/favoritas_repository.dart';
import 'package:cripto_moedas/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  MoedasPage({Key? key}) : super(key: key);

  @override
  _MoedasPageState createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  late List<Moeda> tabela;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Moeda> selecionadas = [];
  late FavoritasRepository favoritas;
  late MoedaRepository moedas;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
            child: ListTile(
          leading: Icon(Icons.swap_vert),
          title: Text('Usar $locale'),
          onTap: () {
            context.read<AppSettings>().setLocale(locale, name);
            Navigator.pop(context);
          },
        )),
      ],
    );
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: Text('Cripto Moedas'),
        actions: [
          changeLanguageButton(),
        ],
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            limparSelecionadas();
          },
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoedasDetalhesPage(moeda: moeda),
      ),
    );
  }

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // favoritas = Provider.of<FavoritasRepository>(context);
    favoritas = context.watch<FavoritasRepository>();
    moedas = context.watch<MoedaRepository>();
    tabela = moedas.tabela;
    readNumberFormat();

    return Scaffold(
      appBar: appBarDinamica(),
      body: RefreshIndicator(
        onRefresh: () => moedas.checkPrecos(),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              leading: (selecionadas.contains(tabela[moeda]))
                  ? CircleAvatar(
                      child: Icon(Icons.check),
                    )
                  : SizedBox(
                      child: Image.network(tabela[moeda].icone),
                      width: 40,
                    ),
              title: Row(
                children: [
                  Text(
                    tabela[moeda].nome,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (favoritas.lista
                      .any((fav) => fav.sigla == tabela[moeda].sigla))
                    Icon(Icons.circle, color: Colors.amber, size: 8),
                ],
              ),
              trailing: Text(
                real.format(tabela[moeda].preco),
                style: TextStyle(fontSize: 15),
              ),
              selected: selecionadas.contains(tabela[moeda]),
              selectedTileColor: Colors.indigo[50],
              onLongPress: () {
                setState(() {
                  (selecionadas.contains(tabela[moeda]))
                      ? selecionadas.remove(tabela[moeda])
                      : selecionadas.add(tabela[moeda]);
                });
              },
              onTap: () => mostrarDetalhes(tabela[moeda]),
            );
          },
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, ___) => Divider(),
          itemCount: tabela.length,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favoritas.saveAll(selecionadas);
                limparSelecionadas();
              },
              icon: Icon(Icons.star),
              label: Text(
                'FAVORITAR',
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
