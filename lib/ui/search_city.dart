import 'package:BarzBRO/ui/bar_city_post.dart';
import 'package:BarzBRO/ui/nbhood_city_post.dart';
import 'package:BarzBRO/ui/user_city_post.dart';
import 'package:flutter/material.dart';
import '../widgets/nav.dart';
import '../widgets/bottom_nav.dart';
import '../services/api_service.dart';
import 'package:strings/strings.dart';

class SearchCityState extends StatefulWidget {
  @override 
  SearchCity createState() => SearchCity();
}

class SearchCity extends State<SearchCityState> {
  String city;
  String bar;
  String neighborhood;
  String user;
  final apiService = ApiService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> barList = [];
  List<String> nbhoodList = [];

  final failSearch = SnackBar(
    content: Text(
      'Make sure you have two fields filled out'
    ),
    backgroundColor: Colors.red,
  );

  getDropdownData(String location) async {
    var barData = await apiService.getBarsInLoc(location);
    if (mounted) {
      setState(() {
        barList.clear();
      });
      setState(() {
        nbhoodList.clear();
      });
    }
    for (var data in barData) {
      if (!barList.contains(data['Bar'])){
        if (mounted) {
          setState(() {
            barList.add(data['Bar']);
          });
        }
      }
    }
    var areaData = await apiService.getPostNbhood(location);
    for (var data in areaData) {
      if (!nbhoodList.contains(data['Neighborhood'])) {
        if (mounted) {
          setState(() {
            nbhoodList.add(data['Neighborhood']);
          });
        }
      }
    }
  }

  searchPost() {
    if (bar != null) {
      String locBar = '$city-$bar';
      Navigator.pushReplacementNamed(context, BarCityPost.route,
      arguments: locBar);
    }
    else if (neighborhood != null) {
      String locNbhood = '$city-$neighborhood';
      Navigator.pushReplacementNamed(context, NbhoodCityPost.route,
      arguments: locNbhood);
    }
    else if (user != null && city != null) {
      String locUser = '$city-$user';
      Navigator.pushReplacementNamed(context, UserCityPost.route,
      arguments: locUser);
    }
    else {
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
          Text('Search City Posts',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
          Text('(Choose the location and one other filter)',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          const Divider(
            thickness: 0.5,
            color: Colors.white,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/search/college');
            },
            child: Text('Search College Posts',
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
             color: Colors.white,
          ),
          Form(
            child: Column(
              children: [
                DropdownButtonFormField(
                  isExpanded: true,
                  items: [
                    'Columbus',
                    'Chicago',
                    'New York',
                    'Denver',
                    'Washington DC',
                    'Minneapolis'
                  ].map((String value) => 
                    DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    )
                  ).toList(), 
                  onChanged: (String value) {
                    getDropdownData(value);
                    setState(() {
                       city = value;
                    });
                  },
                  hint: Text('City'),
                ),
                const Divider(
                  thickness: 0.75,
                  color: Colors.white,
                ),
                DropdownButtonFormField(
                  isExpanded: true,
                  items: barList.map((String value) =>
                  DropdownMenuItem(
                    child: Text(capitalize(value)),
                    value: value
                  )
                  ).toList(),
                  onChanged: (value) => {
                    setState(() => {
                      bar = value
                    })
                  },
                  hint: Text('Bar'),
                ),
                const Divider(
                  thickness: 0.75,
                  color: Colors.white,
                ),
                DropdownButtonFormField(
                  isExpanded: true,
                  items: nbhoodList.map((String value) => 
                  DropdownMenuItem(
                    child: Text(capitalize(value)),
                    value: value,
                  )
                  ).toList(),
                  onChanged: (value) => {
                    setState(() => {
                      neighborhood = value
                    })
                  },
                  hint: Text('Neighborhood'),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User'
                  ),
                  onChanged: (value) => {
                    setState(() => {
                      user = value
                    })
                  },
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
                RaisedButton(
                  child: Text('Search',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)
                  ),
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