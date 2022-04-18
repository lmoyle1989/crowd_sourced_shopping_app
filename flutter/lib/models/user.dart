class User {
  String? firstName;
  String? lastName;
  String? password;
  String? email;
  //String? username; do we want a username in addition to email? seems like a decent idea for the live feed
  int? uploadsCount;
  String? userRank;

  User({
    this.firstName,
    this.lastName,
    this.password,
    this.email,
    //this.username,
    this.uploadsCount,
    this.userRank,
  });
}
