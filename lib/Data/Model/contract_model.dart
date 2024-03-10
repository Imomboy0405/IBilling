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
  bool? deleted;

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
    this.deleted,
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
    deleted = json['deleted'];
  }

  ContractModel.copy(ContractModel model) {
    uId = model.uId;
    key = model.key;
    face = model.face;
    fullName = model.fullName;
    address = model.address;
    tin = model.tin;
    status = model.status;
    createdDate = model.createdDate;
    number = model.number;
    deleted = model.deleted;
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
    map['deleted'] = deleted;
    return map;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContractModel &&
        other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
