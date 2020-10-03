import 'package:flutter/material.dart';
import 'package:BarzBRO/services/cognito_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavState extends StatefulWidget {
  @override
  BottomNav createState() => BottomNav();
}

class BottomNav extends State<BottomNavState> {
  final userService = new CognitoService();

  @override
  void initState() {
    super.initState();
  }

  _bottomTap(int index) async {
    final prefs = await SharedPreferences.getInstance();

    switch (index) {
      case 0:
        {
          Navigator.pushReplacementNamed(context, '/home');
        }
        break;

      case 1:
        {
          Navigator.pushReplacementNamed(context, '/post/user');
        }
        break;

      case 2:
        {
          Navigator.pushReplacementNamed(context, '/search/city');
        }
        break;

      case 3:
        {
          await userService.init();
          await userService.signOut();
          Navigator.pushReplacementNamed(context, '/signin');
          prefs.clear();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.red),
      child: BottomNavigationBar(
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment), title: Text('My Posts')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')),
          BottomNavigationBarItem(
              icon: Icon(Icons.chevron_right), title: Text('Log Out')),
        ],
        onTap: _bottomTap,
      ),
    );
  }
}
