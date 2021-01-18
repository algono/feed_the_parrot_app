import 'dart:io';

import 'package:feed_the_parrot/HomePage.dart';
import 'package:feed_the_parrot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();

  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _codeController,
                maxLines: 1,
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                        .loginInputEmptyErrorMessage;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  hintText: AppLocalizations.of(context).loginInputHint,
                  labelText: AppLocalizations.of(context).loginInputLabel,
                ),
              ),
              Builder(
                  builder: (context) => RaisedButton(
                        child: Text(
                            AppLocalizations.of(context).loginButtonTooltip),
                        onPressed: _isLoggingIn
                            ? null
                            : () async {
                                setState(() => _isLoggingIn = true);

                                if (_formKey.currentState.validate()) {
                                  await _signInWithCode(
                                      context, _codeController.text);
                                }

                                setState(() => _isLoggingIn = false);
                              },
                      )),
              _isLoggingIn
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Usage: flutter (run|build) --dart-define=LOGIN_API_URL=somevalue --dart-define=LOGIN_API_KEY=othervalue
  static const String LOGIN_API_URL = String.fromEnvironment('LOGIN_API_URL'),
      LOGIN_API_KEY = String.fromEnvironment('LOGIN_API_KEY');

  Future _signInWithCode(BuildContext context, String code) async {
    var response = await http
        .get('$LOGIN_API_URL/$code', headers: {'X-API-KEY': LOGIN_API_KEY});

    if (response.statusCode == HttpStatus.ok) {
      String token = response.body;

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token);

      Navigator.of(context).pushReplacement<Null, Null>(MaterialPageRoute<Null>(
          builder: (BuildContext context) => MyHomePage(
                user: userCredential.user,
              )));
    } else {
      var localizations = AppLocalizations.of(context);
      String message;
      switch (response.statusCode) {
        case HttpStatus.unauthorized:
          message = localizations.invalidCodeErrorMessage;
          break;
        case HttpStatus.requestedRangeNotSatisfiable:
          message = localizations.expiredCodeErrorMessage;
          break;
        default:
          message = localizations.unknownErrorMessage;
          break;
      }

      // SnackBar is the material design official "Toast"
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
