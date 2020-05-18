import 'dart:mirrors';

import 'package:mirrorme2/mirrorme2.dart';

const Autowired = _Autowired();

class _Autowired {
  const _Autowired();
}

const Bean = _Bean();

class _Bean {
  const _Bean();
}

const Config = _Config();

class _Config {
  const _Config();
}

const Component = _Component();

class _Component {
  const _Component();
}

class Value {
  final String name;
  final String defaultValue;

  const Value(this.name, {this.defaultValue: ""});
}

class InjectionHandler {
  static Map<String, Object> _singletons = {};

  static Map<String, dynamic> classList = {};

  static Object _injectValue(Object obj) {
    // List<MetaDataValue<Value>> varMirrorModels = MetaDataHelper<Value, VariableMirror>().from(obj);

    // for (MetaDataValue<Value> varMM in varMirrorModels) {
    //   Value value = varMM.object;

    //   varMM.instanceMirror.setField(varMM.memberName, _messageContext.message(value.name, defaultValue: value.defaultValue));
    // }

    return obj;
  }

  static Object _inject(Object obj) {
    List<MetaDataValue<_Autowired>> varMirrorModels = MetaDataHelper<_Autowired, VariableMirror>().from(obj);

    for (MetaDataValue<_Autowired> varMM in varMirrorModels) {
      var value = _singletons[varMM.name];

      if (value == null) {
        Type type = varMM.typeOfOwner();

        value = getBeanByType(type);
      }

      if (value != null) {
        varMM.instanceMirror.setField(varMM.memberName, value);
      }
    }

    return obj;
  }

  static Object getBeanByType(Type type) {
    for (var obj in _singletons.values) {
      if (obj.runtimeType == type) {
        return obj;
      }
    }

    return null;
  }

  static void performScan() {
    var objects = [];

    Scanner<_Config>().scan().forEach((obj) {
      objects.add(obj);
    });

    print("Objects are: $objects");

    objects.forEach((obj) {
      List<MetaDataValue<_Bean>> mirrorValues = MetaDataHelper<_Bean, MethodMirror>().from(obj);

      for (MetaDataValue mv in mirrorValues) {
        InstanceMirror res = mv.invoke([]);

        String beanName = mv.name;

        if (res != null && res.hasReflectee) {
          _singletons[beanName] = res.reflectee;
        }
      }

      _singletons.forEach((key, value) {
        _injectValue(value);
      });
    });

    for (var obj in objects) {
      var result = MetaDataHelper<_Autowired, VariableMirror>().from(obj);
      
      print(result);
    }
  }

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