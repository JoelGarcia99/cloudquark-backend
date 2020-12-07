import 'dart:convert';

import 'package:cloudquark/language.dart';
import 'package:cloudquark/state/provider.dart';
import 'package:flutter/material.dart';

import 'package:cloudquark/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
 
void main()async{
  await DotEnv().load('.env');
  
  final lang = "english";
  final langData = await rootBundle.loadString("assets/${lang}_text.json");

  new AppLanguage().fromJSON(json.decode(langData) ?? {});


  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ProviderState(
      child: MaterialApp(
        title: 'CloudQuark',
        initialRoute: 'home',
        theme: _lightTheme(),
        routes: routes,
      )
    );
  }
}

ThemeData _lightTheme(){
  return ThemeData(
    secondaryHeaderColor: Color.fromRGBO(32, 36, 38, 1.0),
  );
}