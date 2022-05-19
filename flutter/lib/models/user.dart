import 'dart:convert';

class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  int? uploadsCount;
  String? userRank;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.uploadsCount,
    this.userRank,
  });

  factory User.fromJSON(String jsonData) {
    Map<String, dynamic> parsedJSON = jsonDecode(jsonData);
    return User(
      firstName: parsedJSON['first_name'],
      lastName: parsedJSON['last_name'],
      email: parsedJSON['email'],
      uploadsCount: parsedJSON['uploads_count'],
      userRank: parsedJSON['user_rank'],
    );
  }
}
