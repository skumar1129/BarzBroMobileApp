class CollegePost {
  final String school;
  final String id;
  final String bar;
  final String content;
  final int timestamp;
  final String username;
  final int rating;
  final String schoolBar;
  final String schoolUser;
  final String schoolReg;
  final String region;

  CollegePost({this.school, this.id, this.bar, this.content, this.timestamp,
  this.username, this.rating, this.schoolBar, this.schoolUser, this.schoolReg,
  this.region});

  factory CollegePost.fromJson(Map<String, dynamic> json) {
    return CollegePost(
      school: json['School'],
      id: json['Id'],
      bar: json['Bar'],
      content: json['Content'],
      timestamp: json['Timestamp'],
      username: json['Username'],
      rating: json['Rating'],
      schoolBar: json['SchoolBar'],
      schoolUser: json['SchoolUser'],
      schoolReg: json['SchoolReg'],
      region: json['Region']
    );
  }
}