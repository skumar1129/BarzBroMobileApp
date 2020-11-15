import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cognito_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:BarzBRO/models/city_post_model.dart';
import 'package:BarzBRO/models/college_post_model.dart';
import 'package:flushbar/flushbar.dart';

List<CityPost> parseCityPosts(dataItems) {
  var response =
      dataItems.map<CityPost>((json) => CityPost.fromJson(json)).toList();

  return response;
}

List<CollegePost> parseCollegePosts(dataItems) {
  return dataItems
      .map<CollegePost>((json) => CollegePost.fromJson(json))
      .toList();
}

class ApiService {
  final userService = new CognitoService();
  final String city_api =
      'https://vzpsdsnfc7.execute-api.us-east-2.amazonaws.com/prod';
  final String college_api =
      'https://wznyup28l6.execute-api.us-east-2.amazonaws.com/prod';

  Future<bool> addCityPost(item) async {
    bool succeed;
    await userService.init();
    String token = await userService.getToken();
    final prefs = await SharedPreferences.getInstance();
    String path = '/post/add/' + prefs.getString('user');
    String endpoint = this.city_api + path;
    Map<String, dynamic> mapBody;

    if (item['neighborhood'] != null) {
      mapBody = {
        'Content': item['content'],
        'Location': item['location'],
        'Bar': item['bar'].toLowerCase(),
        'LocBar': item['location'] + '-' + item['bar'].toLowerCase(),
        'LocUser': item['location'] + '-' + prefs.getString('user'),
        'LocNeighborhood':
            item['location'] + '-' + item['neighborhood'].toLowerCase(),
        'Rating': item['rating'],
        'Neighborhood': item['neighborhood'].toLowerCase()
      };
    } else {
      mapBody = {
        'Content': item['content'],
        'Location': item['location'],
        'Bar': item['bar'].toLowerCase(),
        'LocBar': item['location'] + '-' + item['bar'].toLowerCase(),
        'LocUser': item['location'] + '-' + prefs.getString('user'),
        'LocNeighborhood': null,
        'Rating': item['rating'],
        'Neighborhood': null
      };
    }

    final reqBody = {'Item': mapBody};

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      await http.post(endpoint, headers: headers, body: jsonEncode(reqBody));
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    return succeed;
  }

  Future<bool> deletePost(String location, int number) async {
    await userService.init();
    String path = '/post/delete/lt/$location/$number';
    String endpoint = this.city_api + path;
    String token = await userService.getToken();
    bool succeed;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      await http.delete(endpoint, headers: headers);
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    return succeed;
  }

  Future<bool> updatePost(item) async {
    await userService.init();
    String path = '/post/update';
    String endpoint = this.city_api + path;
    String token = await userService.getToken();
    bool succeed;

    Map<String, dynamic> reqBody = {
      'Item': {
        'Content': item['content'],
        'Bar': item['bar'],
        'Username': item['username'],
        'Rating': item['rating'],
        'Location': item['location'],
        'Timestamp': item['timestamp'],
        'Id': item['id'],
        'LocBar': item['locBar'],
        'LocUser': item['locUser'],
        'Neighborhood': item['neighborhood'],
        'LocNeighborhood': item['locNeighborhood']
      }
    };

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      await http.patch(endpoint, headers: headers, body: jsonEncode(reqBody));
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    return succeed;
  }

  Future<List<CityPost>> getCityPosts(String location, BuildContext context,
      [int start]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/l/$location?limit=5';
    var response;
    if (start != null && start > 0) {
      path += '&start=$start';
    }
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);

    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<List<CityPost>> getCityPostsRating(
      String location, BuildContext context,
      [int start, int rating]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/lr/$location?limit=5';

    var response;
    if (start != null && start > 0) {
      path += '&start=$start&rating=$rating';
    }
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<List<CityPost>> getCityUserTime(String locUser, BuildContext context,
      [int start, String location]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/lut/$locUser?limit=5';
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&location=$location';
    }
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<List<CityPost>> getCityUserRating(String locUser, BuildContext context,
      [int start, String location, int rating]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/lur/$locUser?limit=5';
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&location=$location&rating=$rating';
    }
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<List<CityPost>> getCityBarTime(String locBar, BuildContext context,
      [int start, String location]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/lbt/$locBar?limit=5';
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&location=$location';
    }
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<List<CityPost>> getCityBarRating(String locBar, BuildContext context,
      [int start, String location, int rating]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/lbr/$locBar?limit=5';
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&location=$location&rating=$rating';
    }
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<List<CityPost>> getUserPost(BuildContext context,
      [int start, String location]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    final prefs = await SharedPreferences.getInstance();
    String path = '/post/u/' + prefs.getString('user') + '?limit=4';
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&location=$location';
    }
    String endpoint = this.city_api + path;
    await userService.init();
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    var jsonReponse = json.decode(response.body);
    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<dynamic> getBarsInLoc(String location) async {
    await userService.init();
    String path = '/post/bar/$location';
    var response;
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    return jsonResponse['Items'];
  }

  Future<dynamic> getPostNbhood(String location) async {
    await userService.init();
    String path = '/post/nbhood/$location';
    var response;
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    return jsonResponse['Items'];
  }

  Future<dynamic> getSchoolBar(String school) async {
    await userService.init();
    String path = '/post/schoolbar/sbb/$school';
    var response;
    String endpoint = this.college_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    return jsonResponse['Items'];
  }

  Future<dynamic> getSchoolReg(String school) async {
    await userService.init();
    String path = '/post/schoolreg/srs/$school';
    var response;
    String endpoint = this.college_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonResponse = json.decode(response.body);
    return jsonResponse['Items'];
  }

  Future<List<CityPost>> getCityNbhoodTime(
      String locNeighborhood, BuildContext context,
      [int start, String location]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/nbhood/nt/$locNeighborhood?limit=5';
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&location=$location';
    }
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    var jsonReponse = json.decode(response.body);
    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<List<CityPost>> getCityNbhoodRating(
      String locNeighborhood, BuildContext context,
      [int start, String location, int rating]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/nbhood/nr/$locNeighborhood?limit';
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&location=$location&rating=$rating';
    }
    String endpoint = this.city_api + path;
    String token = await userService.getToken();

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    var jsonReponse = json.decode(response.body);
    return compute(parseCityPosts, jsonReponse['Items']);
  }

  Future<bool> addCollegePost(item) async {
    await userService.init();
    bool succeed;
    String token = await userService.getToken();
    final prefs = await SharedPreferences.getInstance();
    String path = '/post/college/create/' + prefs.getString('user');
    String endpoint = this.college_api + path;
    Map<String, dynamic> mapBody;

    if (item['region'] != null) {
      mapBody = {
        'Content': item['content'],
        'School': item['school'],
        'Bar': item['bar'].toLowerCase(),
        'SchoolBar': item['school'] + '-' + item['bar'].toLowerCase(),
        'SchoolUser': item['school'] + '-' + prefs.getString('user'),
        'SchoolReg': item['school'] + '-' + item['region'].toLowerCase(),
        'Rating': item['rating'],
        'Region': item['region'].toLowerCase()
      };
    } else {
      mapBody = {
        'Content': item['content'],
        'School': item['school'],
        'Bar': item['bar'].toLowerCase(),
        'SchoolBar': item['school'] + '-' + item['bar'].toLowerCase(),
        'SchoolUser': item['school'] + '-' + prefs.getString('user'),
        'SchoolReg': null,
        'Rating': item['rating'],
        'Region': null
      };
    }

    final reqBody = {'Item': mapBody};

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      await http.post(endpoint, headers: headers, body: jsonEncode(reqBody));
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }
    return succeed;
  }

  Future<bool> deleteCollegePost(String school, int number) async {
    await userService.init();
    String path = '/post/college/delete/$school/$number';
    String endpoint = this.college_api + path;
    String token = await userService.getToken();
    bool succeed;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      await http.delete(endpoint, headers: headers);
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    return succeed;
  }

  Future<bool> updateCollegePost(item) async {
    await userService.init();
    String path = '/post/college/update';
    String endpoint = this.college_api + path;
    String token = await userService.getToken();
    bool succeed;

    Map<String, dynamic> reqBody = {
      'Item': {
        'Content': item['content'],
        'Bar': item['bar'],
        'Username': item['username'],
        'Rating': item['rating'],
        'School': item['school'],
        'Timestamp': item['timestamp'],
        'Id': item['id'],
        'SchoolBar': item['schoolBar'],
        'SchoolUser': item['schoolUser'],
        'Region': item['region'],
        'SchoolReg': item['schoolReg']
      }
    };

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    print(reqBody);
    try {
      await http.patch(endpoint, headers: headers, body: jsonEncode(reqBody));
      succeed = true;
    } catch (e) {
      print(e);
      succeed = false;
    }

    return succeed;
  }

  Future<List<CollegePost>> getCollegePostTime(
      String college, BuildContext context,
      [int start]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/school/sr/$college?limit=5';
    String token = await userService.getToken();
    var response;

    if (start != null && start > 0) {
      path += '&start=$start';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }

    var jsonReponse = json.decode(response.body);

    return compute(parseCollegePosts, jsonReponse['Items']);
  }

  Future<List<CollegePost>> getCollegePostRating(
      String college, BuildContext context,
      [int start, int rating]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/school/st/$college?limit=5';
    String token = await userService.getToken();
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&rating=$rating';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCollegePosts, jsonReponse['Items']);
  }

  Future<List<CollegePost>> getCollegeBarTime(
      String schoolBar, BuildContext context,
      [int start, String school]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/schoolbar/sbt/$schoolBar?limit=5';
    String token = await userService.getToken();
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&school=$school';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCollegePosts, jsonReponse['Items']);
  }

  Future<List<CollegePost>> getCollegeBarRating(
      String schoolBar, BuildContext context,
      [int start, String school, int rating]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/schoolbar/sbr/$schoolBar?limit=5';
    String token = await userService.getToken();
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&school=$school&rating=$rating';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCollegePosts, jsonReponse['Items']);
  }

  Future<List<CollegePost>> getSchoolRegTime(
      String schoolReg, BuildContext context,
      [int start, String school]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/schoolreg/srt/$schoolReg?limit=5';
    String token = await userService.getToken();
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&school=$school';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCollegePosts, jsonReponse['Items']);
  }

  Future<List<CollegePost>> getSchoolRegRating(
      String schoolReg, BuildContext context,
      [int start, String school, int rating]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/schoolreg/srr/$schoolReg?limit=5';
    String token = await userService.getToken();
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&school=$school&rating=$rating';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCollegePosts, jsonReponse['Items']);
  }

  Future<List<CollegePost>> getSchoolUserTime(
      String schoolUser, BuildContext context,
      [int start, String school]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/schooluser/sut/$schoolUser?limit=5';
    String token = await userService.getToken();
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&school=$school';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);

    return compute(parseCollegePosts, jsonReponse['Items']);
  }

  Future<List<CollegePost>> getSchoolUserRating(
      String schoolUser, BuildContext context,
      [int start, String school, int rating]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    String path = '/post/schooluser/sur/$schoolUser?limit=5';
    String token = await userService.getToken();
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&school=$school&rating=$rating';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCollegePosts, jsonReponse['Items']);
  }

  Future<List<CollegePost>> getSchoolUser(BuildContext context,
      [int start, String school]) async {
    bool authPass;
    authPass = await userService.init();
    if (!authPass) {
      Flushbar(
        title: 'Authenication Error',
        message: 'You will need to sign in again',
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1000),
      )..show(context);
      Timer(Duration(milliseconds: 1000), () async {
        await userService.signOut();
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
    final prefs = await SharedPreferences.getInstance();
    String path = '/post/school/u/' + prefs.getString('user') + '?limit=5';
    String token = await userService.getToken();
    var response;
    if (start != null && start > 0) {
      path += '&start=$start&school=$school';
    }
    String endpoint = this.college_api + path;

    Map<String, String> headers = {
      'service': 'dev-barzbro-api-city',
      'region': 'us-east-2',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      response = await http.get(endpoint, headers: headers);
    } catch (e) {
      print(e);
    }
    var jsonReponse = json.decode(response.body);
    return compute(parseCollegePosts, jsonReponse['Items']);
  }
}
