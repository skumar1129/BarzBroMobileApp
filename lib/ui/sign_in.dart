import 'package:flutter/material.dart';
import '../services/cognito_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInState extends StatefulWidget {
  @override 
  SignIn createState() => SignIn();
}

class SignIn extends State<SignInState> {
  final userService = new CognitoService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String username;
  String password;
  final success = SnackBar(
    content: Text(
      'Log In Successful'
    ),
    backgroundColor: Colors.green,
  );
  final fail = SnackBar(
    content: Text(
      'Error Signing In, make sure your username and password are correct'
    ),
    backgroundColor: Colors.red,
  );

  signIn(username, password, context) async {
    final prefs = await SharedPreferences.getInstance();
    bool succeed = await userService.signInUser(username, password);
    if (succeed) {
      prefs.setString('user', username);
       _scaffoldKey.currentState.showSnackBar(success);
      Navigator.pushReplacementNamed(context, '/home');
    }
    else {
       _scaffoldKey.currentState.showSnackBar(fail);
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
            const SizedBox(
                height: 30,
            ),
            Text('Welcome to Barz BRO!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.white
            ),
            Text('Sign in or sign up and start posting!',
              style: TextStyle(
                fontSize: 20
              ),
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.white
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: Text('Go to Sign Up Page',
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
            const Divider(
              thickness: 0.5,
              color: Colors.white
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username'
              ),
              onChanged: (value) => {
                if (mounted) {      
                  setState(() =>{
                    username = value
                  })
                }
              },
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.white
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
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
              thickness: 0.5,
              color: Colors.white
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/forgot');
                  },
                child: Text('Forgot Password',
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
                    signIn(username, password, context);
                  },
                  child: Text('Sign In',
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
              ],
              ),
            Expanded(
              child: Image(image: AssetImage('assets/img/sign_in.jpg'),),
              flex: 1,
            )
          ]
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  } 
}