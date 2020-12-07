import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LanguageState {

  BehaviorSubject<String> _language = new BehaviorSubject<String>();

  Stream<String> get languageStream => _language.stream;
  Function(String) get languageSink => _language.sink.add;
  Future<String> get language => _language.last;

  dispose(){
    _language?.close();
  }

}