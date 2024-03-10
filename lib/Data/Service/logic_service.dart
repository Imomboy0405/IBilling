import 'package:i_billing/Data/Model/contract_model.dart';
import 'package:i_billing/Data/Model/invoice_model.dart';
import 'package:intl/intl.dart';

class LogicService {

  static bool compareDate(String date1, String date2, String date0) {
    DateTime dateTime1 = DateTime.parse(date1);
    DateTime dateTime2 = DateTime.parse(date2);
    DateTime dateTime0 = DateTime.parse(date0);

    return dateTime1.isBefore(dateTime0) && dateTime2.isAfter(dateTime0)
        || dateTime0.isAtSameMomentAs(dateTime1) || dateTime0.isAtSameMomentAs(dateTime2);
  }

  static bool compareStatus({
    required bool filterInProcess,
    required bool filterIQ,
    required bool filterPaid,
    required bool filterPayme,
    required String status,
  }) {
    switch (status) {
      case ('Paid'): if (filterPaid) {
        return true;
      } else {
        break;
      }
      case ('In process'): if (filterInProcess) {
        return true;
      } else {
        break;
      }
      case ('Rejected by IQ'): if (filterIQ) {
        return true;
      } else {
        break;
      }
      case ('Rejected by Payme'): if (filterPayme) {
        return true;
      } else {
        break;
      }
    }
    return false;
  }

  static bool checkFullName(String fullName) {
    if (fullName.replaceAll(' ', '').length > 5 &&
        fullName.trim().contains(' ') &&
        fullName.trim().substring(0, fullName.trim().indexOf(' ')).length > 2 &&
        fullName.trim().substring(fullName.trim().lastIndexOf(' '), fullName.trim().length).length > 3) {
      return true;
    }
    return false;
  }

  static bool checkEmail(String email) {
    if (email.contains('@') &&
        email.contains('.') &&
        email.substring(0, email.indexOf('@')).isNotEmpty &&
        email.substring(email.indexOf('@') + 1, email.indexOf('.')).isNotEmpty &&
        email.substring(email.indexOf('.') + 1, email.length).isNotEmpty) {
      return true;
    }
    return false;
  }

  static bool checkPassword(String password) {
    if (password.length > 5 &&
        !password.contains(' ') &&
        (password.contains(RegExp('[a-z]')) || password.contains(RegExp('[A-Z]'))) &&
        password.contains(RegExp('[0-9]')) &&
        !password.trim().contains(' ')) {
      return true;
    }
    return false;
  }

  static String parseError(String e) {
    return e.substring(e.indexOf('/')+1, e.indexOf(']'));
  }

  static String weekDayName({required int day, required int month, required int year}) {
    DateTime date = DateTime(year, month, day);
    return DateFormat('EEEE').format(date).substring(0,2);
  }

  static List<ContractModel> filterContractList({required int day, required month, required int year, required List<ContractModel> list}) {
    List<ContractModel> result = [];
    String dateTime = DateTime(year, month, day).toString().substring(0, 10);
    for (ContractModel model in list) {
      if (model.key!.substring(0, 10) == dateTime) result.add(model);
    }
    return result;
  }

  static List<InvoiceModel> filterInvoiceList({required int day, required month, required int year, required List<InvoiceModel> list}) {
    List<InvoiceModel> result = [];
    String dateTime = DateTime(year, month, day).toString().substring(0, 10);
    for (InvoiceModel model in list) {
      if (model.key!.substring(0, 10) == dateTime) result.add(model);
    }
    return result;
  }
}