import 'package:cloudquark/state/directory_state.dart';
import 'package:cloudquark/state/language_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderState extends InheritedWidget{
  
  final _language = LanguageState();
  final _directory = DirectoryState();
  
  static ProviderState _instance;

  factory ProviderState({ Key key, Widget child }){
    if(_instance == null){
      _instance = new ProviderState._internal(key: key, child: child );
    }

    return _instance;
  }

  ProviderState._internal({ Key key, Widget child })
    : super(key: key, child: child );

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  LanguageState ofLanguage(BuildContext context){
    return context.findAncestorWidgetOfExactType<ProviderState>()._language;
  }

  DirectoryState ofDirectory(BuildContext context){
    return context.findAncestorWidgetOfExactType<ProviderState>()._directory;
  }

}