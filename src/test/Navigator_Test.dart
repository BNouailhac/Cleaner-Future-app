import 'package:flutter_test/flutter_test.dart';
import '../lib/Controller/controllerClass/Navigatorbar.dart';

void main() {
  test('Navigatorbar Test', () async {
    // Create the widget by telling the tester to build it.
    Navigatorbar connection = new Navigatorbar();
    //print('data: $connection');
    // Create the Finders.
    expect(connection.toString(), "Navigatorbar");
  });
}
