import 'dart:convert';

SavedModel savedModelFromJson(String str) => SavedModel.fromJson(json.decode(str));
String savedModelToJson(SavedModel data) => json.encode(data.toJson());

class SavedModel {
  String? uId;
  List<String>? savedContracts;
  List<String>? savedInvoices;

  SavedModel({
      this.uId, 
      this.savedContracts,
      this.savedInvoices,
  });

  SavedModel.fromJson(dynamic json) {
    uId = json['uId'];
    if (json['savedContracts'] != null) {
      savedContracts = [];
      json['savedContracts'].forEach((v) {
        savedContracts?.add(v);
      });
    }
    if (json['savedInvoices'] != null) {
      savedInvoices = [];
      json['savedInvoices'].forEach((v) {
        savedInvoices?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uId'] = uId;
    if (savedContracts != null) {
      map['savedContracts'] = savedContracts?.map((v) => v).toList();
    }
    if (savedInvoices != null) {
      map['savedInvoices'] = savedInvoices?.map((v) => v).toList();
    }
    return map;
  }

}