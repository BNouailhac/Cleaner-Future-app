import 'package:flutter_test/flutter_test.dart';
import '../lib/Model/modelClass/MariaDB.dart';
String _email = "";
MariaDB db = new MariaDB();

Future<String> signIn(String email, String password) async {
  

  var result = await db.gettables("user", '*');

  for (var i = 0; i < result.length; i++) {
    if (email == result[i]["email"] && password == result[i]["password"]) {
      _email = email;
      return ("OK");
    }
  }
  return "NO";
}

Future<String> signUp(String email, String password) async {

  try {
    await db.addUser(email, password);
    return "OK";
  } catch (e) {
    return ("NO");
  }
}

String getCurrentUser() {
  return _email;
}

void main() {
  test('signIn Test', () async {

    final result = await signIn("baptistedemonaco@gmail.com", "azerty");
    // Create the Finders.
    expect(result, "OK");
  });

  test('signUp Test', () async {

    final result = await signUp("baptistedemonaco@gmail.com", "azerty");
    // Create the Finders.
    expect(result, "OK");
  });

  test('getCurrentUser Test', () async {

    final result = await signIn("baptistedemonaco@gmail.com", "azerty");
    var currentUser = getCurrentUser();
    // Create the Finders.
    expect(result, "OK");
    expect(currentUser, "baptistedemonaco@gmail.com");
  });
}
