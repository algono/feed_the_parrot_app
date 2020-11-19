import 'package:cloud_functions/cloud_functions.dart';
import 'package:feed_the_parrot/HomePage.dart';
import 'package:feed_the_parrot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                    return AppLocalizations.of(context).loginInputEmptyErrorMessage;
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
              RaisedButton(
                child: Text(AppLocalizations.of(context).loginButtonTooltip),
                onPressed: _isLoggingIn
                    ? null
                    : () async {
                        setState(() => _isLoggingIn = true);

                        if (_formKey.currentState.validate()) {
                          await _signInWithCode(context, _codeController.text);
                        }

                        setState(() => _isLoggingIn = false);
                      },
              ),
              _isLoggingIn
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future _signInWithCode(BuildContext context, String code) async {
    var signInWithAuthCode = CloudFunctions.instance
        .getHttpsCallable(functionName: 'signInWithAuthCode');

    var token = await signInWithAuthCode.call(<String, dynamic>{
      'code': code,
    });

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCustomToken(token.data);

    Navigator.of(context).pushReplacement<Null, Null>(MaterialPageRoute<Null>(
        builder: (BuildContext context) => MyHomePage(
              user: userCredential.user,
            )));
  }
}
