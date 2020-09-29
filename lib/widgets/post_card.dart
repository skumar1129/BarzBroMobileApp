import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:strings/strings.dart';
import 'dart:convert';


class PostCard extends StatelessWidget {
  final String bar;
  final String location;
  final String username;
  final String content;
  final int rating;
  final int timestamp;
  final String neighborhood;
  


  PostCard(this.bar, this.location, this.username, this.content, 
  this.rating, this.timestamp, this.neighborhood);


  @override
  Widget build(BuildContext context) {
    String goodContent = utf8.decode(content.codeUnits);
    String goodUsername = utf8.decode(username.codeUnits);
    String goodNbhood = utf8.decode(neighborhood.codeUnits);
    String goodBar = utf8.decode(bar.codeUnits);
    String goodLocation = utf8.decode(location.codeUnits);
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return Card(
      color: Colors.black,
      child: Column(
        children: [
          ListTile(
            title: Text(
              capitalize(goodBar),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Merriweather-Bold'
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
          Text(
            goodContent,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Merriweather-Regular'
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  goodUsername,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular'
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  'User Rating: $rating/10',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular'
                  ),
                )
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.5,
          ),
          Row(
            children: [
              Flexible(  
                child: Text(
                  timeago.format(date),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Italic'
                  ),
                  softWrap: true,
                ),
              ),
              Flexible(
                child: Text(
                  capitalize(goodNbhood)+', $goodLocation',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular'
                  ),
                  softWrap: true,
                )
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}