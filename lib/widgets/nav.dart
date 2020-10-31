import 'package:BarzBRO/ui/college_post.dart';
import 'package:flutter/material.dart';
import 'package:BarzBRO/ui/city_post.dart';
import 'package:BarzBRO/ui/college_post.dart';

class NavBarState extends StatefulWidget {
  @override
  NavBar createState() => NavBar();
}

class NavBar extends State<NavBarState> {
  String city = '';
  String college = '';

  clickCollegeTab(String college) {
    String routeParam = '';
    switch (college) {
      case 'tOSU':
        {
          routeParam = 'Ohio State';
        }
        break;

      case 'U of M':
        {
          routeParam = 'Michigan';
        }
        break;

      case 'Mich St':
        {
          routeParam = 'Michigan State';
        }
        break;

      case 'Penn St':
        {
          routeParam = 'Penn State';
        }
        break;

      case 'U of I':
        {
          routeParam = 'Illinois';
        }
        break;

      case 'Wisco':
        {
          routeParam = 'Wisconsin';
        }
        break;
    }

    Navigator.pushReplacementNamed(context, CollegePost.route,
        arguments: routeParam);
  }

  clickCityTab(String city) {
    String routeParam = '';
    switch (city) {
      case 'Cbus':
        {
          routeParam = 'Columbus';
        }
        break;

      case 'Chi Town':
        {
          routeParam = 'Chicago';
        }
        break;

      case 'NY':
        {
          routeParam = 'New York';
        }
        break;

      case 'Denver':
        {
          routeParam = 'Denver';
        }
        break;

      case 'DC':
        {
          routeParam = 'DC';
        }
        break;

      case 'Minn':
        {
          routeParam = 'Minneapolis';
        }
    }
    Navigator.pushReplacementNamed(
      context,
      CityPost.route,
      arguments: routeParam,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Barz BRO',
        style: TextStyle(fontFamily: 'Oxygen-Regular'),
      ),
      backgroundColor: Colors.red,
      centerTitle: true,
      actions: <Widget>[
        Container(
            child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            focusColor: Colors.grey,
            items: ['Cbus', 'Chi Town', 'NY', 'Denver', 'DC', 'Minn']
                .map((String value) => DropdownMenuItem<String>(
                      child: Text(
                        value,
                      ),
                      value: value,
                    ))
                .toList(),
            isDense: true,
            onChanged: (String value) {
              clickCityTab(value);
            },
            icon: Icon(Icons.location_city),
            iconEnabledColor: Colors.white,
          ),
        )),
        Container(
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            focusColor: Colors.grey,
            items: ['tOSU', 'U of M', 'Mich St', 'Penn St', 'U of I', 'Wisco']
                .map((String value) => DropdownMenuItem(
                      child: Text(
                        value,
                      ),
                      value: value,
                    ))
                .toList(),
            isDense: true,
            onChanged: (String value) {
              clickCollegeTab(value);
            },
            icon: Icon(Icons.school),
            iconEnabledColor: Colors.white,
          )),
        ),
        const SizedBox(
          width: 50,
        )
      ],
    );
  }
}
