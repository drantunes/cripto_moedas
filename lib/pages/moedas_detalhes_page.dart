import 'package:cripto_moedas/configs/app_settings.dart';
import 'package:cripto_moedas/models/moeda.dart';
import 'package:cripto_moedas/repositories/conta_repository.dart';
import 'package:cripto_moedas/widgets/grafico_historico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';
// import 'package:social_share/social_share.dart';

class MoedasDetalhesPage extends StatefulWidget {
  final Moeda moeda;

  const MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  State<MoedasDetalhesPage> createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  late NumberFormat real;
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  double quantidade = 0;
  late ContaRepository conta;
  Widget grafico = Container();
  bool graficoLoaded = false;

  getGrafico() {
    if (!graficoLoaded) {
      grafico = GraficoHistorico(moeda: widget.moeda);
      graficoLoaded = true;
    }
    return grafico;
  }

  comprar() async {
    if (_form.currentState!.validate()) {
      // Salvar a compra
      await conta.comprar(widget.moeda, double.parse(_valor.text));

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra realizada com sucesso!')),
      );
    }
  }

  compartilharPreco() {
    final moeda = widget.moeda;
    SocialShare.shareOptions(
      "Confira o preço do ${moeda.nome} agora: ${real.format(moeda.preco)}",
    );
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();
    conta = Provider.of<ContaRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: compartilharPreco,
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      widget.moeda.icone,
                      scale: 2.5,
                    ),
                    Container(width: 10),
                    Text(
                      real.format(widget.moeda.preco),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              getGrafico(),
              (quantidade > 0)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        // padding: EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: Text(
                          '$quantidade ${widget.moeda.sigla}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.teal,
                          ),
                        ),
                        // decoration: BoxDecoration(
                        //   color: Colors.teal.withOpacity(0.05),
                        // ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(bottom: 24),
                    ),
              Form(
                key: _form,
                child: TextFormField(
                  controller: _valor,
                  style: const TextStyle(fontSize: 22),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Valor',
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                    suffix: Text(
                      'reais',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o valor da compra';
                    } else if (double.parse(value) < 50) {
                      return 'Compra mínima é R\$ 50,00';
                    } else if (double.parse(value) > conta.saldo) {
                      return 'Você não tem saldo suficiente';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      quantidade = (value.isEmpty) ? 0 : double.parse(value) / widget.moeda.preco;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: comprar,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Comprar',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  readNumberFormat() {
    final loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }
}
