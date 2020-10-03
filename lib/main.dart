import 'package:BarzBRO/ui/edit_city_post.dart';
import 'package:BarzBRO/ui/edit_college_post.dart';
import 'package:BarzBRO/ui/search_city.dart';
import 'package:BarzBRO/ui/search_college.dart';
import 'package:BarzBRO/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'ui/sign_in.dart';
import 'ui/add_post_college.dart';
import 'ui/sign_up.dart';
import 'ui/add_post.dart';
import 'ui/bar_city_post.dart';
import 'ui/bar_city_rating_post.dart';
import 'ui/bar_college_post.dart';
import 'ui/bar_college_rating_post.dart';
import 'ui/city_post.dart';
import 'ui/college_post.dart';
import 'ui/college_rating_post.dart';
import 'ui/city_rating_post.dart';
import 'ui/home.dart';
import 'ui/my_post.dart';
import 'ui/my_post_college.dart';
import 'ui/nbhood_city_post.dart';
import 'ui/nbhood_city_rating_post.dart';
import 'ui/nbhood_college_post.dart';
import 'ui/nbhood_college_rating_post.dart';
import 'ui/user_city_post.dart';
import 'ui/user_city_rating_post.dart';
import 'ui/user_college_post.dart';
import 'ui/user_college_rating_post.dart';
import 'ui/forgot_password.dart';

void main() {
  runApp(MyApp());
}

// TODO: redeploy the website too i guess lol

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barz BRO',
      theme: ThemeData(fontFamily: 'CrimsonText-Bold'),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenState(),
        '/signin': (context) => SignInState(),
        '/signup': (context) => SignUpState(),
        '/forgot': (context) => ForgotState(),
        '/home': (context) => Home(),
        '/search/city': (context) => SearchCityState(),
        '/search/college': (context) => SearchCollegeState(),
        '/post/user': (context) => MyPostState(),
        '/post/create': (context) => AddPostState(),
        '/post/school/user': (context) => MyPostCollegeState(),
        '/post/school/create': (context) => AddPostCollegeState(),
      },
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          BarCityPost.route: (context) => BarCityPostState(settings.arguments),
          BarCityRatingPost.route: (context) =>
              BarCityRatingPostState(settings.arguments),
          BarCollegePost.route: (context) =>
              BarCollegePostState(settings.arguments),
          BarCollegeRatingPost.route: (context) =>
              BarCollegeRatingPostState(settings.arguments),
          CityPost.route: (context) => CityPostState(settings.arguments),
          CityRatingPost.route: (context) =>
              CityRatingPostState(settings.arguments),
          CollegePost.route: (context) => CollegePostState(settings.arguments),
          CollegeRatingPost.route: (context) =>
              CollegeRatingPostState(settings.arguments),
          NbhoodCityPost.route: (context) =>
              NbhoodCityPostState(settings.arguments),
          NbhoodCityRatingPost.route: (context) =>
              NbhoodCityRatingPostState(settings.arguments),
          NbhoodCollegePost.route: (context) =>
              NbhoodCollegePostState(settings.arguments),
          NbhoodCollegeRatingPost.route: (context) =>
              NbhoodCollegeRatingPostState(settings.arguments),
          UserCityPost.route: (context) =>
              UserCityPostState(settings.arguments),
          UserCityRatingPost.route: (context) =>
              UserCityRatingPostState(settings.arguments),
          UserCollegePost.route: (context) =>
              UserCollegePostState(settings.arguments),
          UserCollegeRatingPost.route: (context) =>
              UserCollegeRatingPostState(settings.arguments),
          EditCityPost.route: (context) =>
              EditCityPostState(settings.arguments),
          EditCollegePost.route: (context) =>
              EditCollegePostState(settings.arguments)
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}
