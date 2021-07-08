import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  // late SharedPreferences _prefs;
  late Box box;
  Map<String, String> locale = {
    'locale': 'pt_BR',
    'name': 'R\$',
  };

  AppSettings() {
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
    await _readLocale();
  }

  Future<void> _startPreferences() async {
    // _prefs = await SharedPreferences.getInstance();
    box = await Hive.openBox('preferencias');
  }

  _readLocale() {
    final local = box.get('local') ?? 'pt_BR';
    final name = box.get('name') ?? 'R\$';
    locale = {
      'locale': local,
      'name': name,
    };
    notifyListeners();
  }

  setLocale(String local, String name) async {
    await box.put('local', local);
    await box.put('name', name);
    await _readLocale();
  }
}
