import 'package:wired2/wired2.dart';

class MyFirstClass {
  String get testout => "This is a test.";
}

// @Autowired
// MyFirstClass v;

class TestClass {
  @Autowired
  MyFirstClass mfc;

  String testout2() {
    return mfc.testout;
  }
}


void main(List<String> args) {
  ApplicationContext.bootstrap();

  print(ApplicationContext.components);
}

@Config
class SomeConfig {
  @Bean
  MyFirstClass myFirstClass() {
    return MyFirstClass();
  }
}