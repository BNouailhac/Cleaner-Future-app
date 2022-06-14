import 'package:flutter/material.dart';
import '../../../Controller/controllerClass/Authentication.dart';
import '../../components/tools/AnimateClass.dart';
import '../../../Model/Language.dart' as globals;

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn, this.connectionerror});

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback connectionerror;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP, FORGOTPASSWORD }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
        } else if (_formMode == FormMode.SIGNUP) {
          userId = await widget.auth.signUp(_email, _password);
          _showVerifyEmailSentDialog();
        } else {
          widget.auth.sendPasswordReset(_email);
          _showPasswordEmailSentDialog();
        }
        setState(() {
          _isLoading = false;
        });

        if (userId == "OK" && _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        } else if (userId == "NO" && _formMode == FormMode.LOGIN) {
          _isLoading = false;
          _errorMessage = globals.langue[7];
        }
      } catch (e) {
        widget.connectionerror();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  void _changeFormToPasswordReset() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.FORGOTPASSWORD;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        _showBody(),
        _showCircularProgress(),
      ],
    ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: AnimateClass());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(globals.langue[5]),
          content:
              new Text(globals.langue[6]),
          actions: <Widget>[
            new FlatButton(
              child: new Text(globals.langue[4]),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPasswordEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(globals.langue[2]),
          content: new Text(globals.langue[3]),
          actions: <Widget>[
            new FlatButton(
              child: new Text(globals.langue[4]),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0), //EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            controller: new ScrollController(),
            //shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showText(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              //_showSecondaryButton(),
              //_showForgotPasswordButton(),
              _showErrorMessage(),
              _showToggleLanguage(),
            ],
          ),
        ));
  }

  Widget _showToggleLanguage() {
    return ListBody(
      children: <Widget>[
        Text(globals.langue[1], textAlign: TextAlign.center),
        new TextButton.icon(
          onPressed: () {
            setState(() {
              if (globals.langue[0] == "Français")
                globals.langue = [
                  "English",
                  "Change language :",
                  "Forgot your password ?",
                  "An email has been sent to reset your password",
                  "Back",
                  "Verify your account",
                  "an email to verify your account has been sent to you",
                  "Bad email or passwords",
                  "Connection",
                  "Nice to see you again",
                  "Email",
                  "Email cannot be empty",
                  "Password",
                  "Password cannot be empty",
                  "You will receive an email to reset your password",
                  "Forgot your password ?",
                  "Connection",
                  "Create an account",
                  "Reset password",
                  "You have an account ? login",
                  "Back",
                  "Unable to reach the server",
                  "Check your connection and restart the application",
                  "Your device has been blocked",
                  "It is possible that your phone is not appropriate or that it is infected by a virus.",
                  "Verify your account",
                  "You have not yet had your account verified",
                  "Resend verification email",
                  "Verify your account",
                  "an email to verify your account has been sent to you",
                  "Email : ",
                  "Name : ",
                  "Phone number : ",
                  "Disconnect", // 33
                  "CleanerFuture Account Registration Confirmation",
                  'Hello,\nYou have just created a CleanerFuture account, click on the following link to finalize your registration: http://localhost:3000/signin',
                  "Change of password for CleanerFuture account",
                  'Hello,\nYou have just requested a password change for your CleanerFuture account, click on the following link to finalize your registration: http://localhost:3000/reset-password', // 37
                  "Alert ",
                  "the level of ",
                  "is preoccupying",
                  "Unable to reach the server",
                  "Check your connection", // 42
                  "Search for a machine...",
                  "Cleaning",
                  "Return",
                  "Stop", //46
                ];
              else
                globals.langue = [
                  "Français",
                  "Changez langue :",
                  "Mot de passe oublié",
                  "Un courriel a été envoyé pour réinitialiser votre mot de passe.",
                  "Retour",
                  "Vérifier votre compte",
                  "un email pour vérifier votre compte vous a été envoyé",
                  "Mauvais email ou mots de passe",
                  "Connexion",
                  "Heureux de vous revoir",
                  "Email",
                  "Email ne peut être vide",
                  "Mot de passe",
                  "Mot de passe ne peut être vide",
                  "Vous allez recevoir un email pour réinitialiser votre mot de passe",
                  "Mot de passe oublié ?",
                  "Connexion",
                  "Créer un compte",
                  "Réinitialiser mot de passe",
                  "Vous avez un compte ? se connecter",
                  "Retour", //20
                  "Impossible d'atteindre le serveur",
                  "Vérifiez votre connection puis redémarrez l'application",
                  "Votre appareil a été bloqué",
                  "Il est possible que votre téléphone ne soit pas approprié ou qu'il soit infecté par un virus.", //24
                  "Vérifier votre compte",
                  "Vous n'avez pas encore fait vérifier votre compte",
                  "Renvoyer email de vérification",
                  "Vérifier votre compte",
                  "un email pour vérifier votre compte vous a été envoyé",
                  "Email : ",
                  "Nom : ",
                  "Numéro : ",
                  "Déconnexion", // 33
                  "Confirmation d'inscription compte CleanerFuture",
                  'Bonjour,\nVous venez de créer un compte CleanerFuture, cliquer sur le lien suivant pour finaliser votre inscription: http://localhost:3000/signin',
                  "Changement de mot de passe compte CleanerFuture",
                  'Bonjour,\nVous venez de faire une demande de changement de mot de passe de votre compte CleanerFuture, cliquer sur le lien suivant pour changer de mot de passe: http://localhost:3000/reset-password', // 37
                  "Alerte ",
                  "le niveau de ",
                  "est préocupant",
                  "Impossible d'atteindre le serveur",
                  "Vérifiez votre connection", // 42
                  "Rechercher une machine...",
                  "Nettoyage",
                  "Rentrer",
                  "Stop", //46
                ];
            });
          },
          icon: Icon(
            // <-- Icon
            Icons.language,
            size: 24.0,
          ),
          label: Text(globals.langue[0]), // <-- Text
        ),
      ],
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 110.0,
      child: Image(
          image: AssetImage("assets/csv/CleanerFutureLogo-text_1022X736.png")),
    );
  }

  Widget _showText() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 0.0),
          child: Text(globals.langue[8],
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 0.0),
          child: Text(globals.langue[9],
              textAlign: TextAlign.left, style: TextStyle(fontSize: 17.5)),
        ),
      ],
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: globals.langue[10],
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? globals.langue[11] : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    if (_formMode != FormMode.FORGOTPASSWORD) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: globals.langue[12],
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? globals.langue[13] : null,
          onSaved: (value) => _password = value.trim(),
        ),
      );
    } else {
      return new Text(
          globals.langue[14],
          style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300));
    }
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 15.0),
        child: SizedBox(
          height: 35.0,
          child: new RaisedButton(
            elevation: 4.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Color(0xFF66BB6A),
            child: _textPrimaryButton(),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _textSecondaryButton(),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showForgotPasswordButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text(globals.langue[15],
              style: new TextStyle(fontSize: 14.5, fontWeight: FontWeight.w300))
          : new Text('',
              style:
                  new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300)),
      onPressed: _changeFormToPasswordReset,
    );
  }

  Widget _textPrimaryButton() {
    switch (_formMode) {
      case FormMode.LOGIN:
        return new Text(globals.langue[16],
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
      case FormMode.SIGNUP:
        return new Text(globals.langue[17],
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
      case FormMode.FORGOTPASSWORD:
        return new Text(globals.langue[18],
            style: new TextStyle(fontSize: 20.0, color: Colors.white));
        break;
    }
    return new Spacer();
  }

  Widget _textSecondaryButton() {
    switch (_formMode) {
      case FormMode.LOGIN:
        return new Text(globals.langue[17],
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300));
        break;
      case FormMode.SIGNUP:
        return new Text(globals.langue[19],
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300));
        break;
      case FormMode.FORGOTPASSWORD:
        return new Text(globals.langue[20],
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300));
        break;
    }
    return new Spacer();
  }
}
