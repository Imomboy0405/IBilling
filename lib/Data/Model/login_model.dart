import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.success,
    this.error,
    this.result,
  });

  Login.fromJson(dynamic json) {
    success = json['success'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  bool? success;
  Error? error;
  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (error != null) {
      map['error'] = error?.toJson();
    }
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }
}

Result resultFromJson(String str) => Result.fromJson(json.decode(str));

String resultToJson(Result data) => json.encode(data.toJson());

class Result {
  Result({
    this.firstName,
    this.lastName,
    this.username,
    this.mail,
    this.phoneNumber,
    this.language,
    this.mailHasBeenSent,
  });

  Result.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    mail = json['mail'];
    phoneNumber = json['phoneNumber'];
    language = json['language'];
    mailHasBeenSent = json['mailHasBeenSent'];
  }

  String? firstName;
  String? lastName;
  String? username;
  String? mail;
  String? phoneNumber;
  String? language;
  bool? mailHasBeenSent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['mail'] = mail;
    map['phoneNumber'] = phoneNumber;
    map['language'] = language;
    map['mailHasBeenSent'] = mailHasBeenSent;
    return map;
  }
}

Error errorFromJson(String str) => Error.fromJson(json.decode(str));

String errorToJson(Error data) => json.encode(data.toJson());

class Error {
  Error({
    this.code,
    this.message,
  });

  Error.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
  }

  num? code;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    return map;
  }

  @override
  String toString() {
    return 'Code: $code\n Message: $message';
  }
}
