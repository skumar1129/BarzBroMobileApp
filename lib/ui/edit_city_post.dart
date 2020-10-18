import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import '../services/api_service.dart';
import '../widgets/nav.dart';
import '../widgets//bottom_nav.dart';

class EditCityPostState extends StatefulWidget {
  EditCityPostState(this.postInfo);
  final postInfo;
  @override
  EditCityPost createState() => EditCityPost();
}

class EditCityPost extends State<EditCityPostState> {
  static const route = '/edit/city/post';
  final apiSerivce = new ApiService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var post;
  String bar;
  String neighborhood;
  int rating;
  String content;

  final successEdit = SnackBar(
    content: Text('Successfully edited your post'),
    backgroundColor: Colors.green,
  );

  final failEdit = SnackBar(
    content: Text('Error updating post check your network connection'),
    backgroundColor: Colors.red,
  );

  final successDelete = SnackBar(
    content: Text('Successfully deleted your post'),
    backgroundColor: Colors.green,
  );

  final failDelete = SnackBar(
    content: Text('Error deleting post check your network connection'),
    backgroundColor: Colors.red,
  );

  submitPost(
      String bar, String neighborhood, int rating, String content) async {
    var item = {
      'id': post.id,
      'location': post.location,
      'timestamp': post.timestamp,
      'username': post.username,
      'locUser': post.locUser,
      'bar': (bar != null) ? bar.toLowerCase() : post.bar,
      'content': (content != null) ? content : post.content,
      'neighborhood': (neighborhood != null)
          ? neighborhood.toLowerCase()
          : post.neighborhood,
      'rating': (rating != null) ? rating : post.rating,
      'locNeighborhood': (neighborhood != null)
          ? post.location + '-' + neighborhood.toLowerCase()
          : post.locNeighborhood,
      'locBar':
          (bar != null) ? post.location + '-' + bar.toLowerCase() : post.locBar
    };
    bool succeed = await apiSerivce.updatePost(item);
    if (succeed) {
      _scaffoldKey.currentState.showSnackBar(successEdit);
      Navigator.pushReplacementNamed(context, '/post/user');
    } else {
      _scaffoldKey.currentState.showSnackBar(failEdit);
    }
  }

  deletePost(post) async {
    bool succeed = await apiSerivce.deletePost(post.location, post.timestamp);
    if (succeed) {
      _scaffoldKey.currentState.showSnackBar(successDelete);
      Navigator.pushReplacementNamed(context, '/post/user');
    } else {
      _scaffoldKey.currentState.showSnackBar(failDelete);
    }
  }

  @override
  void initState() {
    super.initState();
    post = widget.postInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          NavBarState(),
          const Divider(
            thickness: 0.5,
            color: Colors.white,
          ),
          Center(
            child: Text(
              'Edit Your Post',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            thickness: 0.5,
            color: Colors.white,
          ),
          Center(
            child: Text(
              post.location,
              style: TextStyle(fontSize: 20),
            ),
          ),
          const Divider(
            thickness: 0.5,
            color: Colors.white,
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/post/user');
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
                  deletePost(post);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
              ),
              RaisedButton(
                onPressed: () {
                  submitPost(bar, neighborhood, rating, content);
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          const Divider(
            thickness: 0.5,
            color: Colors.white,
          ),
          Form(
              child: Expanded(
                  child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bar',
                      hintText: capitalize(post.bar)),
                  onChanged: (value) => {
                    if (mounted)
                      {
                        setState(() => {bar = value})
                      }
                  },
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Neighborhood',
                      hintText: capitalize(post.neighborhood)),
                  onChanged: (value) => {
                    if (mounted)
                      {
                        setState(() => {neighborhood = value})
                      }
                  },
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.white,
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
                  thickness: 0.75,
                  color: Colors.white,
                ),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'What\'s good?*',
                      hintText: post.content),
                  onChanged: (value) => {
                    if (mounted)
                      {
                        setState(() => {content = value})
                      }
                  },
                ),
              ],
            ),
          ))),
        ],
      ),
      bottomNavigationBar: BottomNavState(),
    );
  }
}
