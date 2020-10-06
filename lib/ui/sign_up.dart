import 'dart:async';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import '../services/cognito_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class SignUpState extends StatefulWidget {
  @override
  SignUp createState() => SignUp();
}

class SignUp extends State<SignUpState> {
  @override
  void initState() {
    super.initState();
    userService.init();
  }

  final userService = new CognitoService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool confirmTime = false;
  String username;
  String email;
  String password;
  String confirm;
  String code;
  final successUser = SnackBar(
    content: Text('Sign up successful, you can sign in with your account now'),
    backgroundColor: Colors.green,
  );
  final successCode = SnackBar(
    content: Text('Code resent'),
    backgroundColor: Colors.green,
  );
  final failUser = SnackBar(
    content: Text('Make sure the code is the most recent sent'),
    backgroundColor: Colors.red,
  );
  final failCode = SnackBar(
    content: Text('Error resending code, check network connection'),
    backgroundColor: Colors.red,
  );
  final successSignUp = SnackBar(
    content: Text('Confirmation code sent out'),
    backgroundColor: Colors.green,
  );
  final failSignUp = SnackBar(
    content: Text('Make sure not to leave fields blank'),
    backgroundColor: Colors.red,
  );
  final failPassword = SnackBar(
    content: Text('Make sure your passwords match'),
    backgroundColor: Colors.red,
  );

  signUp(username, email, password, confirm) async {
    final attributes = [new AttributeArg(name: 'email', value: email)];
    var message;
    if (password == confirm && email != null) {
      message = await userService.signUpUser(username, password, attributes);
      if (message == 'Success') {
        _scaffoldKey.currentState.showSnackBar(successSignUp);
        if (mounted) {
          setState(() {
            confirmTime = true;
          });
        }
      } else {
        if (message ==
                '1 validation error detected: Value at \'password\' failed to satisfy constraint: Member must have length greater than or equal to 6' ||
            message ==
                'Password did not conform with policy: Password not long enough') {
          message =
              'Password must have a length of at least 8 characters with a number and uppercase character';
        }
        if (message ==
                '2 validation errors detected: Value at \'password\' failed to satisfy constraint: Member must not be null; Value at \'username\' failed to satisfy constraint: Member must not be null' ||
            message ==
                '1 validation error detected: Value at \'password\' failed to satisfy constraint: Member must not be null') {
          message = 'Make sure not to leave fields blank';
        }
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else if (email == null) {
      _scaffoldKey.currentState.showSnackBar(failSignUp);
    } else {
      _scaffoldKey.currentState.showSnackBar(failPassword);
    }
  }

  resendCode() async {
    bool succeed = false;
    succeed = await userService.resendCode(username);
    if (succeed) {
      _scaffoldKey.currentState.showSnackBar(successCode);
    } else {
      _scaffoldKey.currentState.showSnackBar(failCode);
    }
  }

  confirmUser() async {
    final prefs = await SharedPreferences.getInstance();
    bool succeed = false;
    succeed = await userService.confirmUser(username, code);
    if (succeed) {
      prefs.setString('user', username);
      _scaffoldKey.currentState.showSnackBar(successUser);
      Timer(Duration(milliseconds: 750), () {
        Navigator.pushReplacementNamed(context, '/signin');
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(failUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (!confirmTime) ...[
              const SizedBox(
                height: 30,
              ),
              Text(
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                child: Text(
                  'Back to Sign In Page',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {username = value})
                    }
                },
              ),
              const Divider(thickness: 0.05, color: Colors.white),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {email = value})
                    }
                },
              ),
              const Divider(thickness: 0.05, color: Colors.white),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {password = value})
                    }
                },
                obscureText: true,
              ),
              const Divider(thickness: 0.05, color: Colors.white),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password'),
                obscureText: true,
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {confirm = value})
                    }
                },
              ),
              RaisedButton(
                onPressed: () {
                  signUp(username, email, password, confirm);
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
              ),
              Expanded(
                child: Image(
                  image: AssetImage('assets/img/sign_up.jpg'),
                ),
                flex: 2,
              )
            ] else ...[
              RaisedButton(
                onPressed: () => {
                  if (mounted)
                    {
                      setState(() => {confirmTime = false})
                    }
                },
                child: Text(
                  'Go back',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
              ),
              Text(
                'Confirm your email with confirmation code',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirmation Code'),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {code = value})
                    }
                },
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        resendCode();
                      },
                      child: Text(
                        'Resend code',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                    ),
                    RaisedButton(
                      onPressed: () {
                        confirmUser();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                    )
                  ])
            ]
          ],
        ),
      ),
    );
  }
}
