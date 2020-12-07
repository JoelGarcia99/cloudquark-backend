import 'package:rxdart/rxdart.dart';

class DirectoryState {
  BehaviorSubject<String> _elements = new BehaviorSubject<String>();
  BehaviorSubject<String> _route = new BehaviorSubject<String>();

  Stream<String> get elementsStream => _elements.stream;
  Function(String) get elementsSink => _elements.sink.add;
  String get elements => _elements.value;

  Stream<String> get routeStream => _route.stream;
  Function(String) get routeSink => _route.sink.add;

  String previousRoute(){
    String newRoute = _route.value;
    final splitted = newRoute.split('>');    
    splitted.removeLast();    
    newRoute = (splitted.length>0)?splitted.join('>'):"";

    routeSink(newRoute);
    return newRoute;
  }

  String nextRoute(String route) {
    print("<here>");
    String newRoute = "";
    
    if(_route.hasValue) {
      print("has value");
      newRoute += _route.value;
      newRoute +=">"+route;
    }
    
    print(newRoute);
    print("</here>");
    routeSink(newRoute);
    return newRoute;
  }

  String get route => _route.value;

  dispose(){
    _elements?.close();
    _route?.close();
  }
}