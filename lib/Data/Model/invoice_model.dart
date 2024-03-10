import 'dart:convert';

InvoiceModel invoiceModelFromJson(String str) => InvoiceModel.fromJson(json.decode(str));
String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  String? uId;
  String? key;
  String? fullName;
  String? serviceName;
  String? amount;
  String? status;
  int? number;
  String? createdDate;
  bool? deleted;

  InvoiceModel({
    this.uId,
    this.key,
    this.fullName,
    this.serviceName,
    this.amount,
    this.status,
    this.number,
    this.createdDate,
    this.deleted,
  });

  InvoiceModel.fromJson(dynamic json) {
    uId = json['uId'];
    key = json['key'];
    fullName = json['fullName'];
    serviceName = json['serviceName'];
    amount = json['amount'];
    status = json['status'];
    number = json['number'];
    createdDate = json['createdDate'];
    deleted = json['deleted'];
  }

  InvoiceModel.copy(InvoiceModel model) {
    uId = model.uId;
    key = model.key;
    fullName = model.fullName;
    serviceName = model.serviceName;
    amount = model.amount;
    status = model.status;
    number = model.number;
    createdDate = model.createdDate;
    deleted = model.deleted;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uId'] = uId;
    map['key'] = key;
    map['fullName'] = fullName;
    map['serviceName'] = serviceName;
    map['amount'] = amount;
    map['status'] = status;
    map['number'] = number;
    map['createdDate'] = createdDate;
    map['deleted'] = deleted;
    return map;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InvoiceModel &&
        other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}