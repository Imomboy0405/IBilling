class LogicService {

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
}