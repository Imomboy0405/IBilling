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

  InvoiceModel({
      this.uId, 
      this.key, 
      this.fullName, 
      this.serviceName, 
      this.amount, 
      this.status, 
      this.number, 
      this.createdDate,});

  InvoiceModel.fromJson(dynamic json) {
    uId = json['uId'];
    key = json['key'];
    fullName = json['fullName'];
    serviceName = json['serviceName'];
    amount = json['amount'];
    status = json['status'];
    number = json['number'];
    createdDate = json['createdDate'];
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
    return map;
  }

}