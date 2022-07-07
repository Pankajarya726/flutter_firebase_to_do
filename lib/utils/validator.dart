class Validator {
  static String? validateField({required String value}) {
    if (value.isEmpty) {
      return 'Field can\'t be empty';
    }

    return null;
  }

  static String? validateUserID({required String uid}) {
    if (uid.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(uid)) {
      return 'Please enter valid email address';
    }

    return null;
  }

  static String? validatePassword({required String uid}) {
    if (uid.isEmpty) {
      return 'Password can\'t be empty';
    } else if (uid.length <= 5) {
      return 'Password should be greater than 5 characters';
    }

    return null;
  }
}
