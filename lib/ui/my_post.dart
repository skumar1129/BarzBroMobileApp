import 'package:flutter/material.dart';
import 'package:BarzBRO/ui/edit_city_post.dart';
import '../widgets/nav.dart';
import '../widgets//bottom_nav.dart';
import '../services/api_service.dart';
import 'package:strings/strings.dart';
import 'dart:convert';

class MyPostState extends StatefulWidget {
  @override
  MyPost createState() => MyPost();
}

class MyPost extends State<MyPostState> {
  final apiService = new ApiService();
  Future<dynamic> posts;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final fail = SnackBar(
    content: Text('Error grabbing posts, check your network connection'),
    backgroundColor: Colors.red,
  );

  getPosts([int start, String location]) async {
    var response;
    if (start != null && location != null) {
      try {
        response = await apiService.getUserPost(context, start, location);
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(fail);
      }
    } else {
      response = await apiService.getUserPost(context);
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    posts = getPosts();
  }

  editPost(post) {
    Navigator.pushReplacementNamed(context, EditCityPost.route,
        arguments: post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(children: <Widget>[
        NavBarState(),
        FutureBuilder(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data;
                if (items.length == 0) {
                  return Expanded(
                      child: Column(
                    children: <Widget>[
                      const Divider(
                        color: Colors.white,
                        thickness: 0.5,
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/post/create');
                            },
                            child: Text(
                              'Create your first post',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/post/school/user');
                            },
                            child: Text(
                              'See your college posts',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                      Text(
                        'Here is a place to see all the posts you make in Cities!',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/img/my_post_page.jpg'),
                        ),
                      ),
                    ],
                  ));
                } else {
                  return Expanded(
                      child: Column(
                    children: [
                      const Divider(
                        color: Colors.white,
                        thickness: 0.5,
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/post/create');
                            },
                            child: Text(
                              'Create a new post',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/post/school/user');
                            },
                            child: Text(
                              'See your college posts',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                      Expanded(
                          child: Scrollbar(
                              child: RefreshIndicator(
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: items.length + 1,
                          itemBuilder: (context, index) {
                            if (index == items.length && items.length >= 4) {
                              int startIndex = items.length - 1;
                              var newPosts = getPosts(
                                  items[startIndex].timestamp,
                                  items[startIndex].location);
                              newPosts.then((posts) {
                                if (posts.length > 0) {
                                  if (mounted) {
                                    setState(() {
                                      items.addAll(posts);
                                    });
                                  }
                                }
                              });
                              return IntrinsicWidth(
                                child: CircularProgressIndicator(),
                              );
                            } else if (index == items.length &&
                                items.length < 4) {
                              return Container();
                            } else {
                              var dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      items[index].timestamp * 1000);
                              var year = dateTime.year.toString().substring(2);
                              var amPm;
                              var hour;
                              var minute;
                              if (dateTime.hour > 12) {
                                hour = dateTime.hour - 12;
                                amPm = 'PM';
                              } else if (dateTime.hour == 0) {
                                hour = 12;
                                amPm = 'AM';
                              } else {
                                hour = dateTime.hour;
                                amPm = 'AM';
                              }
                              if (dateTime.minute < 10) {
                                minute = '0${dateTime.minute}';
                              } else {
                                minute = dateTime.minute.toString();
                              }
                              String goodContent =
                                  utf8.decode(items[index].content.codeUnits);
                              String goodUsername =
                                  utf8.decode(items[index].username.codeUnits);
                              String goodNbhood = utf8
                                  .decode(items[index].neighborhood.codeUnits);
                              String goodBar =
                                  utf8.decode(items[index].bar.codeUnits);
                              String goodLocation =
                                  utf8.decode(items[index].location.codeUnits);
                              return Card(
                                color: Colors.black,
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        capitalize(goodBar),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Merriweather-Bold'),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.white,
                                    ),
                                    Text(
                                      goodContent,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Merriweather-Regular'),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        editPost(items[index]);
                                      },
                                      child: Text(
                                        'Edit Post',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)),
                                    ),
                                    const Divider(
                                      color: Colors.white,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            goodUsername,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                    'Merriweather-Regular'),
                                            softWrap: true,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            'User Rating: ${items[index].rating}/10',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                    'Merriweather-Regular'),
                                            softWrap: true,
                                          ),
                                        )
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 0.5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            '${dateTime.month}/${dateTime.weekday}/$year, $hour:$minute $amPm',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                    'Merriweather-Italic'),
                                            softWrap: true,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            '${capitalize(goodNbhood)}, $goodLocation',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                    'Merriweather-Regular'),
                                            softWrap: true,
                                          ),
                                        )
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 0.5,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        onRefresh: () {
                          return getPosts();
                        },
                      ))),
                    ],
                  ));
                }
              } else if (snapshot.hasError) {
                return Expanded(
                    child: Column(
                  children: [
                    const Divider(
                      thickness: 0.5,
                      color: Colors.white,
                    ),
                    Text(
                      'There was an error getting the posts',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Image(
                        image: AssetImage('assets/img/my_post_page.jpg'),
                      ),
                    )
                  ],
                ));
              }
              return CircularProgressIndicator();
            }),
      ]),
      bottomNavigationBar: BottomNavState(),
    );
  }
}
