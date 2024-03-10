import 'package:firebase_database/firebase_database.dart';
import 'package:i_billing/Data/Model/history_model.dart';
import 'package:i_billing/Data/Model/contract_model.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:i_billing/Data/Model/saved_model.dart';
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


  static Future<Stream<DatabaseEvent>> storeHistory(HistoryModel historyModel) async {
    await database
        .child('histories')
        .child('${historyModel.uId}')
        .set(historyModel.toJson());
    return database.onChildAdded;
  }

  static Future<Stream<DatabaseEvent>> deleteHistory(HistoryModel historyModel) async {
    await database.child('histories').child(historyModel.uId!).remove();
    return database.onChildAdded;
  }

  static Future<HistoryModel> loadHistory(String uId) async {
    Query query = database.child('histories').child(uId);
    DatabaseEvent event = await query.once();
    HistoryModel historyModel = HistoryModel.fromJson(event.snapshot.value);
    return historyModel;
  }


  static Future<Stream<DatabaseEvent>> storeContract(ContractModel contractModel) async {
    await database.child('contracts').child(contractModel.uId!).child(contractModel.key!).set(contractModel.toJson());
    return database.onChildAdded;
  }

  static Future<Stream<DatabaseEvent>> deleteContract(ContractModel contractModel) async {
    await database.child('contracts').child(contractModel.uId!).child(contractModel.key!).remove();
    return database.onChildAdded;
  }

  static Future<List<ContractModel>> loadContracts(String uId) async {
    List<ContractModel> contracts = [];
    Query query = database.child('contracts').child(uId);
    var event = await query.once();
    contracts = parseSnapshotContracts(event);
    return contracts;
  }

  static List<ContractModel> parseSnapshotContracts(DatabaseEvent event) {
    List<ContractModel> items = [];
    var result = event.snapshot.children;

    for (DataSnapshot item in result) {
      if (item.value != null) {
        items.add(ContractModel.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }
    return items;
  }


  static Future<Stream<DatabaseEvent>> storeInvoice(InvoiceModel invoiceModel) async {
    await database.child('invoices').child(invoiceModel.uId!).child(invoiceModel.key!).set(invoiceModel.toJson());
    return database.onChildAdded;
  }

  static Future<Stream<DatabaseEvent>> deleteInvoice(InvoiceModel invoiceModel) async {
    await database.child('invoices').child(invoiceModel.uId!).child(invoiceModel.key!).remove();
    return database.onChildAdded;
  }

  static Future<List<InvoiceModel>> loadInvoices(String uId) async {
    List<InvoiceModel> invoices = [];
    Query query = database.child('invoices').child(uId);
    var event = await query.once();
    invoices = parseSnapshotInvoices(event);
    return invoices;
  }

  static List<InvoiceModel> parseSnapshotInvoices(DatabaseEvent event) {
    List<InvoiceModel> items = [];
    var result = event.snapshot.children;

    for (DataSnapshot item in result) {
      if (item.value != null) {
        items.add(InvoiceModel.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }
    return items;
  }


  static Future<Stream<DatabaseEvent>> storeSaved(SavedModel savedModel) async {
    await database
        .child('saved')
        .child('${savedModel.uId}')
        .set(savedModel.toJson());
    return database.onChildAdded;
  }

  static Future<Stream<DatabaseEvent>> deleteSaved(SavedModel historyModel) async {
    await database.child('saved').child(historyModel.uId!).remove();
    return database.onChildAdded;
  }

  static Future<SavedModel> loadSaved(String uId) async {
    Query query = database.child('saved').child(uId);
    DatabaseEvent event = await query.once();
    SavedModel savedModel = SavedModel.fromJson(event.snapshot.value);
    return savedModel;
  }

}