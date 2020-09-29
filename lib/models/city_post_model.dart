class CityPost {
  final String location;
  final String id;
  final String bar;
  final String content;
  final int timestamp;
  final String username;
  final int rating;
  final String locBar;
  final String locUser;
  final String locNeighborhood;
  final String neighborhood;
  final Map<String, String>lastKey;

  CityPost({this.location, this.id, this.bar, this.content, this.timestamp,
  this.username, this.rating, this.locBar, this.locUser, this.locNeighborhood,
  this.neighborhood, this.lastKey});

  factory CityPost.fromJson(Map<String, dynamic> json) {
    return CityPost(
      location: json['Location'],
      id: json['Id'],
      bar: json['Bar'],
      content: json['Content'],
      timestamp: json['Timestamp'],
      username: json['Username'],
      rating: json['Rating'],
      locBar: json['LocBar'],
      locUser: json['LocUser'],
      locNeighborhood: json['LocNeighborhood'],
      neighborhood: json['Neighborhood'],
      lastKey: json['LastEvaluatedKey']
    );
  }
}