import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_moedas/databases/db_firestore.dart';
import 'package:cripto_moedas/models/moeda.dart';
import 'package:cripto_moedas/repositories/moeda_repository.dart';
import 'package:cripto_moedas/services/auth_service.dart';
import 'package:flutter/material.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Moeda> _lista = [];
  late FirebaseFirestore db;
  late AuthService auth;
  MoedaRepository moedas;

  FavoritasRepository({required this.auth, required this.moedas}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readFavoritas();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readFavoritas() async {
    if (auth.usuario != null && _lista.isEmpty) {
      try {
        final snapshot = await db
            .collection('usuarios/${auth.usuario!.uid}/favoritas')
            .get();

        snapshot.docs.forEach((doc) {
          Moeda moeda = moedas.tabela
              .firstWhere((moeda) => moeda.sigla == doc.get('sigla'));
          _lista.add(moeda);
          notifyListeners();
        });
      } catch (e) {
        print('Sem id de usuário');
      }
    }
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    moedas.forEach((moeda) async {
      if (!_lista.any((atual) => atual.sigla == moeda.sigla)) {
        _lista.add(moeda);
        await db
            .collection('usuarios/${auth.usuario!.uid}/favoritas')
            .doc(moeda.sigla)
            .set({
          'moeda': moeda.nome,
          'sigla': moeda.sigla,
          'preco': moeda.preco,
        });
      }
    });
    notifyListeners();
  }

  remove(Moeda moeda) async {
    await db
        .collection('usuarios/${auth.usuario!.uid}/favoritas')
        .doc(moeda.sigla)
        .delete();
    _lista.remove(moeda);
    notifyListeners();
  }
}
