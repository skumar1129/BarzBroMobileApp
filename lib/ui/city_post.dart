import 'package:BarzBRO/ui/city_rating_post.dart';
import 'package:flutter/material.dart';
import '../widgets/nav.dart';
import '../widgets//bottom_nav.dart';
import '../services/api_service.dart';
import '../widgets/post_card.dart';

class CityPostState extends StatefulWidget {
  CityPostState(this.location);
  final String location;
  @override
  CityPost createState() => CityPost();
}

class CityPost extends State<CityPostState> {
  static const route = '/city';
  final apiService = new ApiService();
  var posts;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final fail = SnackBar(
    content: Text('Error grabbing posts, check your network connection'),
    backgroundColor: Colors.red,
  );

  getPosts(String location, [int start]) async {
    var response;
    if (start != null) {
      try {
        response = await apiService.getCityPosts(location, context, start);
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(fail);
      }
    } else {
      response = await apiService.getCityPosts(location, context);
    }
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posts = getPosts(widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          NavBarState(),
          FutureBuilder(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var items = snapshot.data;
                if (items.length == 0) {
                  return Expanded(
                      child: Column(
                    children: [
                      const Divider(
                        color: Colors.white,
                        thickness: 0.5,
                      ),
                      Row(children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/post/create');
                          },
                          child: Text(
                            'Create First Post',
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
                                context, CityRatingPost.route,
                                arguments: widget.location);
                          },
                          child: Text(
                            'Sort By Rating',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                        )
                      ], mainAxisAlignment: MainAxisAlignment.spaceAround),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                      Text(
                        'No posts for ${widget.location} yet...',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Image(
                          image: AssetImage('assets/img/city_page.jpg'),
                        ),
                      )
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
                      Text(
                        '${widget.location}',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oxygen-Bold'),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.5,
                      ),
                      Row(children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/post/create');
                          },
                          child: Text(
                            'Create New Post',
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
                                context, CityRatingPost.route,
                                arguments: widget.location);
                          },
                          child: Text(
                            'Sort By Rating',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                        )
                      ], mainAxisAlignment: MainAxisAlignment.spaceAround),
                      Expanded(
                          child: Scrollbar(
                              child: RefreshIndicator(
                                  child: ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: items.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == items.length &&
                                            items.length >= 5) {
                                          int startIndex = items.length - 1;
                                          var newPosts = getPosts(
                                              items[startIndex].location,
                                              items[startIndex].timestamp);
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
                                            items.length < 5) {
                                          return Container();
                                        }
                                        return (PostCard(
                                            items[index].bar,
                                            items[index].location,
                                            items[index].username,
                                            items[index].content,
                                            items[index].rating,
                                            items[index].timestamp,
                                            items[index].neighborhood));
                                      }),
                                  onRefresh: () {
                                    return getPosts(widget.location);
                                  })))
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
                        image: AssetImage('assets/img/city_page.jpg'),
                      ),
                    )
                  ],
                ));
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavState(),
    );
  }
}
