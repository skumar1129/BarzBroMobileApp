import 'package:flutter/material.dart';
import 'package:BarzBRO/services/cognito_service.dart';

class ForgotState extends StatefulWidget {
  @override
  ForgotPassword createState() => ForgotPassword();
}

class ForgotPassword extends State<ForgotState> {
  final userService = new CognitoService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String username;
  bool submittedUser = false;
  String code;
  String newPassword;
  String confirm;
  final successUser = SnackBar(
    content: Text('Found User, code sent out'),
    backgroundColor: Colors.green,
  );
  final successCode = SnackBar(
    content: Text('Successfully changed password'),
    backgroundColor: Colors.green,
  );
  final failUser = SnackBar(
    content: Text('Make sure the username exists'),
    backgroundColor: Colors.red,
  );
  final failCode = SnackBar(
    content: Text('Make sure the code is the most recent code sent'),
    backgroundColor: Colors.red,
  );

  sendUsername() async {
    await userService.init();
    bool succeed = await userService.forgotPassword(username);
    if (succeed) {
      if (mounted) {
        setState(() {
          submittedUser = true;
        });
      }
      _scaffoldKey.currentState.showSnackBar(successUser);
    } else {
      _scaffoldKey.currentState.showSnackBar(failUser);
    }
  }

  changePassword() async {
    await userService.init();
    if (newPassword == confirm) {
      bool succeed =
          await userService.changePassword(username, code, newPassword);
      if (succeed) {
        _scaffoldKey.currentState.showSnackBar(successCode);
        Navigator.pushReplacementNamed(context, '/signin');
      } else {
        _scaffoldKey.currentState.showSnackBar(failCode);
      }
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
            Text(
              'Fill out the information to reset your password',
              style: TextStyle(fontSize: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signin');
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
                RaisedButton(
                  onPressed: () {
                    sendUsername();
                  },
                  child: submittedUser == true
                      ? Text(
                          'Resend code',
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                )
              ],
            ),
            if (submittedUser) ...[
              Text(
                'Fill in the code and new password or hit submit above to resend the code',
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Verification code',
                ),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {code = value})
                    }
                },
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New password',
                ),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {newPassword = value})
                    }
                },
                obscureText: true,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm password',
                ),
                onChanged: (value) => {
                  if (mounted)
                    {
                      setState(() => {confirm = value})
                    }
                },
                obscureText: true,
              ),
              RaisedButton(
                onPressed: () {
                  changePassword();
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
            ]
          ],
        ),
      ),
    );
  }
}
