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
  final userService = new CognitoService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool confirmTime = false;
  String username;
  String email;
  String password;
  String confirm;
  String code;
  final successUser = SnackBar(
    content: Text(
      'Sign up successful'
    ),
    backgroundColor: Colors.green,
  );
  final successCode = SnackBar(
    content: Text(
      'Code resent'
    ),
    backgroundColor: Colors.green,
  );
  final failUser = SnackBar(
    content: Text(
      'Make sure the code is the most recent sent'
    ),
    backgroundColor: Colors.red,
  );
  final failCode = SnackBar(
    content: Text(
      'Error resending code, check network connection'
    ),
    backgroundColor: Colors.red,
  );
  final successSignUp = SnackBar(
    content: Text(
      'Confirmation code sent out'
    ),
    backgroundColor: Colors.green,
  );
  final failSignUp = SnackBar(
    content: Text(
      'Make sure to fill in all the required information and that the password is longer than 6 letters, has a number, and capital letter'
    ),
    backgroundColor: Colors.red,
  );
  final failPasswrod = SnackBar(
    content: Text(
      'Make sure your passwords match'
    ),
    backgroundColor: Colors.red,
  );


  signUp(username, email, password, confirm) async {
    final attributes = [new AttributeArg(name: 'email', value: email)];
    bool succeed = false;
    if (password == confirm) {
      succeed = await userService.signUpUser(username, password, attributes);
      if (succeed) {
        _scaffoldKey.currentState.showSnackBar(successSignUp);
        if (mounted) {      
          setState(() {
            confirmTime = true;
          });
        }
      }
      else {
         _scaffoldKey.currentState.showSnackBar(failSignUp);
      }
    } else {
       _scaffoldKey.currentState.showSnackBar(failPasswrod);
    }
  }

  resendCode() async {
    bool succeed = false;
    succeed = await userService.resendCode(username);
    if (succeed) {
      _scaffoldKey.currentState.showSnackBar(successCode);
    }
    else {
      _scaffoldKey.currentState.showSnackBar(failCode);
    }
   
    
  }

  confirmUser() async {
    bool succeed = false;
    final prefs = await SharedPreferences.getInstance();
    succeed = await userService.confirmUser(username, code);
    if (succeed) {
      prefs.setString('user', username);
       _scaffoldKey.currentState.showSnackBar(successUser);
      Navigator.pushReplacementNamed(context, '/home');
    }
    else {
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
          if (!confirmTime)...[
            const SizedBox(
                  height: 30,
            ), 
            Text('Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Back to Sign In Page',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username'
              ),
              onChanged: (value) => {
                if (mounted) {      
                  setState(() => {
                    username = value
                  })
                }
              },
            ),
            const Divider(
              thickness: 0.05,
              color: Colors.white
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email'
              ),
              onChanged: (value) => {
                if (mounted) {      
                  setState(() => {
                    email = value
                  })
                }
              },
            ),
            const Divider(
              thickness: 0.05,
              color: Colors.white
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password'
              ),
              onChanged: (value) => {
                if (mounted) {      
                  setState(() => {
                    password = value
                  })
                }
              },
              obscureText: true,
            ),
            const Divider(
              thickness: 0.05,
              color: Colors.white
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password'
              ),
               obscureText: true,
               onChanged: (value) => {
                if (mounted) {      
                  setState(() => {
                    confirm = value
                  })
                }
               },
            ),
            RaisedButton(
              onPressed: () {
                signUp(username, email, password, confirm);
              },
              child: Text('Sign Up',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)
              ),
            ),
            Expanded(
              child: Image(image: AssetImage('assets/img/sign_up.jpg'),),
              flex: 2,
            )
          ]
          else...[
            RaisedButton(
              onPressed: () => {
                if (mounted) {      
                  setState(() => {
                    confirmTime = false
                  })
                }
              },
              child: Text('Go back',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)
                ),
            ),
            Text('Confirm your email with confirmation code',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            TextField(
              decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirmation Code'
                  ),
                  onChanged: (value) => {
                    if (mounted) {      
                      setState(() =>{
                        code = value
                      })
                    }
                  },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                RaisedButton(
                  onPressed: () {
                    resendCode();
                  },
                child: Text('Resend code',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)
                ),
                ),
              RaisedButton(
                onPressed: () {
                  confirmUser();
                },
                child: Text('Submit',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)
                ),
              )
              ]
            )
          ]
          ],
          ),
        ),
        resizeToAvoidBottomPadding: false,
    );
  } 
}