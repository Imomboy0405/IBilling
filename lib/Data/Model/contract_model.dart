import 'dart:convert';

ContractModel contractModelFromJson(String str) => ContractModel.fromJson(json.decode(str));
String contractModelToJson(ContractModel data) => json.encode(data.toJson());

class ContractModel {
  String? uId;
  String? key;
  String? face;
  String? fullName;
  String? address;
  int? tin;
  String? status;
  String? createdDate;
  int? number;

  ContractModel({
      this.uId,
      this.key,
      this.face,
      this.fullName,
      this.address, 
      this.tin, 
      this.status,
      this.createdDate,
      this.number,
  });

  ContractModel.fromJson(dynamic json) {
    uId = json['uId'];
    key = json['key'];
    face = json['face'];
    fullName = json['fullName'];
    address = json['address'];
    tin = json['tin'];
    status = json['status'];
    createdDate = json['createdDate'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uId'] = uId;
    map['key'] = key;
    map['face'] = face;
    map['fullName'] = fullName;
    map['address'] = address;
    map['tin'] = tin;
    map['status'] = status;
    map['createdDate'] = createdDate;
    map['number'] = number;
    return map;
  }
}