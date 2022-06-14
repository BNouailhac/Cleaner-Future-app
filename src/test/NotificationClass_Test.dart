import 'package:flutter_test/flutter_test.dart';
import '../lib/View/Components/tools/NotificationClass.dart';

void main() {
  test('Navigatorbar Test', () async {
    var result = "NO";
    try {
      NotificationClass _notificationclass = new NotificationClass();
      result = "OK";
    } catch (e) {
    }

    expect(result, "OK");
  });
}
