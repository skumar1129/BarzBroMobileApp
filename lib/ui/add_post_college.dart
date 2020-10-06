import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/nav.dart';
import '../widgets//bottom_nav.dart';

class AddPostCollegeState extends StatefulWidget {
  @override
  AddPostCollege createState() => AddPostCollege();
}

class AddPostCollege extends State<AddPostCollegeState> {
  final apiSerivce = new ApiService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String school;
  String bar;
  String neighborhood;
  int rating;
  String content;

  final successAdd = SnackBar(
    content: Text('Successfully made your post'),
    backgroundColor: Colors.green,
  );

  final failAdd = SnackBar(
    content: Text(
        'Make sure you fill out all the required fields or check your network connection'),
    backgroundColor: Colors.red,
  );

  final failForm = SnackBar(
    content: Text('Make sure all the required fields are filled out'),
    backgroundColor: Colors.red,
  );

  submitPost(String school, String bar, String neighborhood, int rating,
      String content) async {
    var item = {
      'school': school,
      'content': content,
      'bar': bar,
      'rating': rating,
      'region': neighborhood
    };
    if (school == null ||
        bar == null ||
        content == null ||
        rating == null ||
        neighborhood == null) {
      _scaffoldKey.currentState.showSnackBar(failForm);
    } else {
      bool succeed = await apiSerivce.addCollegePost(item);
      if (succeed) {
        _scaffoldKey.currentState.showSnackBar(successAdd);
        Navigator.pushReplacementNamed(context, '/post/school/user');
      } else {
        _scaffoldKey.currentState.showSnackBar(failAdd);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          NavBarState(),
          Center(
            child: Text(
              'Create a New College Post',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
          ),
          Form(
            child: Column(
              children: <Widget>[
                DropdownButtonFormField(
                  items: [
                    'Ohio State',
                    'Michigan',
                    'Michigan State',
                    'Penn State',
                    'Illinois',
                    'Wisconsin'
                  ]
                      .map((String value) => DropdownMenuItem<String>(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (String value) {
                    if (mounted) {
                      setState(() {
                        school = value;
                      });
                    }
                  },
                  hint: Text('College*'),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.75,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Bar*'),
                  onChanged: (value) => {
                    if (mounted)
                      {
                        setState(() => {bar = value})
                      }
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.5,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Area of campus*'),
                  onChanged: (value) => {
                    if (mounted)
                      {
                        setState(() => {neighborhood = value})
                      }
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.5,
                ),
                DropdownButtonFormField(
                  items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                      .map((String value) => DropdownMenuItem<String>(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (String value) {
                    if (mounted) {
                      setState(() {
                        rating = int.parse(value);
                      });
                    }
                  },
                  hint: Text('Rating*'),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.75,
                ),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'What\'s good?*'),
                  onChanged: (value) => {
                    if (mounted)
                      {
                        setState(() => {content = value})
                      }
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.5,
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/post/school/user');
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                    ),
                    RaisedButton(
                      onPressed: () {
                        submitPost(school, bar, neighborhood, rating, content);
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
