import 'dart:mirrors';

class InjectionHandler {
  static Map<String, dynamic> classList = {};

  static void registerType(name, type) {
    classList[name] = reflectClass(type);
  }

  static void registerFunc(name, Function f) {
    classList[name] = f;
  }

  static dynamic instantiate(name) {
    if (classList[name] is Function) {
      return classList[name]();
    }
    
    return classList[name].newInstance(Symbol(''), []).reflectee;
  }
}