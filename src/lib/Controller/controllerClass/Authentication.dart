import 'dart:async';
import '../../Model/modelClass/MariaDB.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:dbcrypt/dbcrypt.dart';
import '../../../Model/Language.dart' as globals;

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  String getCurrentUser();

  Future<void> sendPasswordReset(String email);
}

class Authentication implements BaseAuth {
  String _email = "";
  MariaDB db = new MariaDB();

  Future<String> signIn(String email, String password) async {
    var result = await db.gettables("user", '*');

    for (var i = 0; i < result.length; i++) {
      var isCorrect = new DBCrypt().checkpw(password, result[i]["password"]);
      if (email == result[i]["email"] && isCorrect) {
        _email = email;
        return ("OK");
      }
    }
    return "NO";
  }

  Future<String> signUp(String email, String password) async {
    try {
      var hashedPassword =
          new DBCrypt().hashpw(password, new DBCrypt().gensalt());
      await db.addUser(email, hashedPassword);

      String mailusername = "cleanerfuturemailauto@gmail.com";
      String mailpassword = "q,ghDd[i";

      final smtpServer = gmail(mailusername, mailpassword);
      // Creating the Gmail server

      // Create our email message.
      final message = Message()
        ..from = Address(mailusername)
        ..recipients.add(email)
        ..subject = globals.langue[34]
        ..text = globals.langue[35];

      final sendReport = await send(message, smtpServer);

      return "OK";
    } catch (e) {
      return ("NO");
    }
  }

  String getCurrentUser() {
    return _email;
  }

  Future<String> sendPasswordReset(String email) async {
    try {
      String mailusername = "cleanerfuturemailauto@gmail.com";
      String mailpassword = "q,ghDd[i";

      final smtpServer = gmail(mailusername, mailpassword);
      // Creating the Gmail server

      // Create our email message.
      final message = Message()
        ..from = Address(mailusername)
        ..recipients.add(email)
        ..subject = globals.langue[36]
        ..text = globals.langue[37];

      await send(message, smtpServer);
      return "OK";
    } catch (e) {
      return ("NO");
    }
  }
}
