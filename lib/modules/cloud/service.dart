import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class CloudService {

  final server = DotEnv().env["HOST"];
  final port = DotEnv().env["PORT"];
  final elements = new BehaviorSubject<Map<String, dynamic>>();

  static CloudService _instance;

  factory CloudService(){
    if(_instance == null){
      _instance = new CloudService._();
    }

    return _instance;
  }

  CloudService._();

  dispose(){
    elements?.close();
  }

  String _cleanAddress(String path){
    if(path==""){
      path = "_";
    }
    if(path[0] == '>'){
      path = path.substring(1);
    }
    return path;
  }

  Future<void> dirElements({String path='_'}) async {

    // Cleaning the path from irrelevant characters
    path = _cleanAddress(path);
    //--------------------------

    final uri = "http://$server:$port/directory/$path";

    final response = await http.get(uri);
    final json = jsonDecode(response.body);

    elements.sink.add(json);
  }

  String getFilePath(String path){
    
    // Cleaning the path
    path = _cleanAddress(path);
    //--------------------------

    final uri = "http://$server:$port/file/$path";
    return uri;
  }

}
