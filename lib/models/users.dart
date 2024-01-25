class Users{
  String? userUID;
  String? userName;
  String? userEmail;
  String? photoUrl;

  Users({
    this.userUID,
    this.userName,
    this.userEmail,
    this.photoUrl,
  });

  Users.fromJson(Map<String, dynamic> json) {
    userUID = json["uid"];
    userName = json["name"];
    userEmail = json["email"];
    photoUrl = json["photoUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uid"] = this.userUID;
    data["name"] = this.userName;
    data["email"] = this.userEmail;
    data["photoUrl"] = this.photoUrl;
    return data;
  }
}