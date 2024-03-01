import 'dart:convert';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));
String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  HistoryModel({
      this.uId,
      this.history,
  });

  HistoryModel.fromJson(dynamic json) {
    uId = json['uId'];
    if (json['history'] != null) {
      history = [];
      json['history'].forEach((v) {
        history?.add(v);
      });
    }
  }
  String? uId;
  List<String>? history;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uId'] = uId;
    if (history != null) {
      map['history'] = history?.map((v) => v).toList();
    }
    return map;
  }

}