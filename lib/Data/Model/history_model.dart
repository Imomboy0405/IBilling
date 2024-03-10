import 'dart:convert';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));
String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  String? uId;
  List<String> history = [];
  List<String> savedHistory = [];
  List<String> historyHistory = [];

  HistoryModel({
      this.uId,
      required this.history,
      required this.savedHistory,
      required this.historyHistory,
  });

  HistoryModel.fromJson(dynamic json) {
    uId = json['uId'];
    if (json['history'] != null) {
      history = [];
      json['history'].forEach((v) {
        history.add(v);
      });
    }
    if (json['savedHistory'] != null) {
      savedHistory = [];
      json['savedHistory'].forEach((v) {
        savedHistory.add(v);
      });
    }
    if (json['historyHistory'] != null) {
      historyHistory = [];
      json['historyHistory'].forEach((v) {
        historyHistory.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uId'] = uId;
    map['history'] = history.map((v) => v).toList();
    map['savedHistory'] = savedHistory.map((v) => v).toList();
    map['historyHistory'] = historyHistory.map((v) => v).toList();
      return map;
  }

}