import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/nav.dart';

class Home extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      children: <Widget>[
        NavBarState(),
        Expanded(
          child: Column(
            children: [
              const Divider(
                thickness: 0.5,
                color: Colors.white
              ),
              Text('Welcome to Barz BRO!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Hindsiliguri-Bold'
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.white
              ),
              Text('Check out the vibes of the bars tonight or check out top bars in your area!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Hindsiliguri-Regular'
                ),
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.white
              ),
              Text('All rated by fellow bros! Pick a city or college campus to get started!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Hindsiliguri-Regular'
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Image(image: AssetImage('assets/img/home_page.jpg'),),),
      ]
    ),
    bottomNavigationBar: BottomNavState(),
    );
  } 
}