import 'package:flutter/material.dart';
import '../widgets/nav.dart';
import '../widgets/bottom_nav.dart';
import '../services/api_service.dart';
import 'package:strings/strings.dart';
import './user_college_post.dart';
import './bar_college_post.dart';
import './nbhood_college_post.dart';

class SearchCollegeState extends StatefulWidget {
  @override
  SearchCollege createState() => SearchCollege();
}

class SearchCollege extends State<SearchCollegeState> {
  String school;
  String bar;
  String neighborhood;
  String user;
  final apiService = ApiService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> barList = [];
  List<String> nbhoodList = [];

  final failSearch = SnackBar(
    content: Text('Make sure you have two fields filled out'),
    backgroundColor: Colors.red,
  );

  getDropdownData(String location) async {
    var barData = await apiService.getSchoolBar(location);
    if (mounted) {
      setState(() {
        barList.clear();
      });
      setState(() {
        nbhoodList.clear();
      });
    }
    for (var data in barData) {
      if (!barList.contains(data['Bar'])) {
        if (mounted) {
          setState(() {
            barList.add(data['Bar']);
          });
        }
      }
    }
    var areaData = await apiService.getSchoolReg(location);
    for (var data in areaData) {
      if (!nbhoodList.contains(data['Region'])) {
        if (mounted) {
          setState(() {
            nbhoodList.add(data['Region']);
          });
        }
      }
    }
  }

  searchPost() {
    if (bar != null) {
      String locBar = '$school-$bar';
      Navigator.pushReplacementNamed(context, BarCollegePost.route,
          arguments: locBar);
    } else if (neighborhood != null) {
      String locNbhood = '$school-$neighborhood';
      Navigator.pushReplacementNamed(context, NbhoodCollegePost.route,
          arguments: locNbhood);
    } else if (user != null && school != null) {
      String locUser = '$school-$user';
      Navigator.pushReplacementNamed(context, UserCollegePost.route,
          arguments: locUser);
    } else {
      _scaffoldKey.currentState.showSnackBar(failSearch);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NavBarState(),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
          ),
          Text(
            'Search College Posts',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            '(Choose the location first and one other filter)',
            style: TextStyle(fontSize: 16.5),
          ),
          const Divider(
            thickness: 0.5,
            color: Colors.white,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/search/city');
            },
            child: Text(
              'Search City Posts',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
          ),
          const Divider(
            thickness: 0.5,
            color: Colors.white,
          ),
          Form(
            child: Column(
              children: [
                DropdownButtonFormField(
                  isExpanded: true,
                  items: [
                    'Ohio State',
                    'Michigan',
                    'Michigan State',
                    'Penn State',
                    'Illinois',
                    'Wisconsin'
                  ]
                      .map((String value) => DropdownMenuItem<String>(
                            child: Text(
                              value,
                              softWrap: true,
                            ),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (String value) {
                    getDropdownData(value);
                    setState(() {
                      school = value;
                    });
                  },
                  hint: Text('College'),
                ),
                const Divider(
                  thickness: 0.75,
                  color: Colors.white,
                ),
                DropdownButtonFormField(
                  isExpanded: true,
                  items: barList
                      .map((String value) => DropdownMenuItem(
                          child: Text(capitalize(value)), value: value))
                      .toList(),
                  onChanged: (value) => {
                    setState(() => {bar = value})
                  },
                  hint: Text('Bar'),
                ),
                const Divider(
                  thickness: 0.75,
                  color: Colors.white,
                ),
                DropdownButtonFormField(
                  isExpanded: true,
                  items: nbhoodList
                      .map((String value) => DropdownMenuItem(
                            child: Text(
                              capitalize(value),
                            ),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (value) => {
                    setState(() => {neighborhood = value})
                  },
                  hint: Text('Area of Campus'),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'User'),
                  onChanged: (value) => {
                    setState(() => {user = value})
                  },
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
                RaisedButton(
                  child: Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    searchPost();
                  },
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavState(),
    );
  }
}
