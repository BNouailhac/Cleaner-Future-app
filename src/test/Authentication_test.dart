import 'package:flutter_test/flutter_test.dart';
import '../lib/Controller/controllerClass/Authentication.dart';

void main() {
  test('signIn Test', () async {
    // Create the widget by telling the tester to build it.

    Authentication connection = new Authentication();

    final result =
        await connection.signIn("baptistedemonaco@gmail.com", "azerty");
    // Create the Finders.
    expect(result, "OK");
  });

  test('signUp Test', () async {
    // Create the widget by telling the tester to build it.
    Authentication connection = new Authentication();

    final result = await connection.signUp("baptistedemonaco@gmail.com", "azerty");
    // Create the Finders.
    expect(result, "OK");
  });

  test('getCurrentUser Test', () async {
    // Create the widget by telling the tester to build it.

    Authentication connection = new Authentication();

    final result =
        await connection.signIn("baptistedemonaco@gmail.com", "azerty");
    var currentUser = connection.getCurrentUser();
    // Create the Finders.
    expect(result, "OK");
    expect(currentUser, "baptistedemonaco@gmail.com");
  });

  test('sendPasswordReset Test', () async {
    // Create the widget by telling the tester to build it.
    Authentication connection = new Authentication();

    final result =
        await connection.sendPasswordReset("baptistedemonaco@gmail.com");
    // Create the Finders.
    expect(result, "OK");
  });
}
