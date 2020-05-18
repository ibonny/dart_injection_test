import 'injection_handler.dart';

class MyFirstClass {
  String _name;

  String testout() => "This is a test.";

  String get name => _name;

  void set name(name) => _name = name;
}

class MySecondClass {
  String testout() => "This is also a test.";
}


void main(List<String> args) {
  InjectionHandler.registerFunc('first', () => MyFirstClass());

  InjectionHandler.registerType('second', MySecondClass);

  var f = InjectionHandler.instantiate('first');

  var g = InjectionHandler.instantiate('second');

  print(f.testout());

  print(g.testout());
}