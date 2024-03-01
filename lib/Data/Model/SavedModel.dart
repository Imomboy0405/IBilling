import 'dart:convert';

SavedModel savedModelFromJson(String str) => SavedModel.fromJson(json.decode(str));
String savedModelToJson(SavedModel data) => json.encode(data.toJson());

class SavedModel {
  SavedModel({
      this.uId, 
      this.saved,});

  SavedModel.fromJson(dynamic json) {
    uId = json['uId'];
    if (json['saved'] != null) {
      saved = [];
      json['saved'].forEach((v) {
        saved?.add(v);
      });
    }
  }
  String? uId;
  List<String>? saved;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uId'] = uId;
    if (saved != null) {
      map['saved'] = saved?.map((v) => v).toList();
    }
    return map;
  }

}