import 'package:firebase_database/firebase_database.dart';
import 'package:i_billing/Data/Model/user_model.dart';

class RTDBService {
  static final database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> storeUser(UserModel userModel) async {
    await database.child('users').child(userModel.uId!).set(userModel.toJson());
    return database.onChildAdded;
  }

  static Future<Stream<DatabaseEvent>> deleteUser(UserModel userModel) async {
    await database.child('users').child(userModel.uId!).remove();
    return database.onChildAdded;
  }

  static Future<UserModel?> loadUser(String uId) async {
    final snapshot = await database.child('users/$uId').get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.value as Map);
    }
    return null;
  }


/*

  static Future<ObservableList<Note>> loadNotes(String userId) async {
    ObservableList<Note> notes = ObservableList.of([]);
    Query query = database.child('notes').child('user:$userId');
    var event = await query.once();
    notes = parseSnapshot(event);
    return notes;
  }

  static ObservableList<Note> parseSnapshot(DatabaseEvent event) {
    ObservableList<Note> items = ObservableList.of([]);
    var result = event.snapshot.children;

    for (DataSnapshot item in result) {
      if (item.value != null) {
        items.add(Note.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }
    return items;
  }

  static Future<Stream<DatabaseEvent>> storeHistory(History history) async {
    await database
        .child('history')
        .child('user:${history.userId}')
        .child('history')
        .set(history.toJson());
    return database.onChildAdded;
  }

  static Future<History> loadHistory(String userId) async {
    History history = History(userId: userId, noteKeys: [], first: null);
    Query query = database.child('history').child('user:$userId');
    DatabaseEvent event = await query.once();
    var result = event.snapshot.children;
    for (DataSnapshot item in result) {
      if (item.value != null) {
        history =
            History.fromJson(Map<String, dynamic>.from(item.value as Map));
      }
    }
    return history;
  }*/
}