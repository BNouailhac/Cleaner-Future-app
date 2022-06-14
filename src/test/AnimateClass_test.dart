import 'package:flutter_test/flutter_test.dart';
import '../lib/View/Components/tools/AnimateClass.dart';

void main() {
  test('Navigatorbar Test', () async {
    // Create the widget by telling the tester to build it.
    AnimateClass _animateclass = new AnimateClass();
    //print('data: $connection');
    // Create the Finders.
    expect(_animateclass.toString(), "AnimateClass");
  });
}
