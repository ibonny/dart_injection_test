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

@Config
class BeanClass {
  @Bean
  MyFirstClass getMyFirstClass() {
    return MyFirstClass();
  }
}

@Autowired
MyFirstClass mfc;

void main(List<String> args) {
  InjectionHandler.performScan();

  print("Here: $mfc");

  InjectionHandler.registerFunc('first', () => MyFirstClass());

  InjectionHandler.registerType('second', MySecondClass);

  // This is equivalent to:
  // @Autowired
  // MyFirstClass f;
  var f = InjectionHandler.instantiate('first');

  var g = InjectionHandler.instantiate('second');

  print(f.testout());

  print(g.testout());
}