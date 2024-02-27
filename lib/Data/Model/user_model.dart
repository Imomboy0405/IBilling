import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));
String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? uId;
  String? email;
  String? phoneNumber;
  String? fullName;
  String? password;
  String? createdTime;

  UserModel({
    required this.uId,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.password,
    required this.createdTime,
  });

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    uId = json['uId'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    fullName = json['fullName'];
    password = json['password'];
    createdTime = json['createdTime'];
  }

  Map<String, String?> toJson() {
    final map = <String, String?>{};
    map['uId'] = uId;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['fullName'] = fullName;
    map['password'] = password;
    map['createdTime'] = createdTime;
    return map;
  }
}