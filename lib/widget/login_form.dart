import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:to_do/screen/notes.dart';
import 'package:to_do/utils/database.dart';
import 'package:to_do/utils/validator.dart';
import 'package:to_do/widget/CustomColors.dart';
import 'package:to_do/widget/custom_form_field.dart';

class LoginForm extends StatefulWidget {
  final FocusNode focusNode1;
  final FocusNode focusNode2;

  const LoginForm({
    Key? key,
    required this.focusNode1,
    required this.focusNode2,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _loginInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginInFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              children: [
                CustomFormField(
                  controller: emailController,
                  focusNode: widget.focusNode1,
                  keyboardType: TextInputType.emailAddress,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateUserID(
                    uid: value,
                  ),
                  label: 'Email',
                  hint: 'Enter your email',
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFormField(
                  controller: passwordController,
                  focusNode: widget.focusNode2,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validatePassword(
                    uid: value,
                  ),
                  label: 'Password',
                  hint: 'Enter your password',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: Container(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    CustomColors.firebaseOrange,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  widget.focusNode1.unfocus();
                  widget.focusNode2.unfocus();

                  if (_loginInFormKey.currentState!.validate()) {
                    signin(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'SING IN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.firebaseGrey,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: Container(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    CustomColors.firebaseOrange,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  widget.focusNode1.unfocus();
                  widget.focusNode2.unfocus();

                  if (_loginInFormKey.currentState!.validate()) {
                    signup(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'SING UP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.firebaseGrey,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signin(BuildContext context) async {
    final firebaseAuth = FirebaseAuth.instance;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    try {
      EasyLoading.show();
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      EasyLoading.dismiss();
      if (credential.user != null) {
        debugPrint("uid-->${credential.user!.uid.toString()}");

        Database.userUid = credential.user!.uid;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NoteScreen(),
          ),
        );
        // Database.addUser(userId: credential.user!.uid);
      }
      debugPrint("credential-->${credential.toString()}");
    } catch (exception) {
      EasyLoading.dismiss();
      EasyLoading.showToast("Error : ${exception.toString()}");
      print(exception.toString());
    }
  }

  void signup(BuildContext context) async {
    final firebaseAuth = FirebaseAuth.instance;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    try {
      EasyLoading.show();
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      EasyLoading.dismiss();
      if (credential.user != null) {
        debugPrint("uid-->${credential.user!.uid.toString()}");

        Database.userUid = credential.user!.uid;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NoteScreen(),
          ),
        );
        // Database.addUser(userId: credential.user!.uid);
      }
      debugPrint("credential-->${credential.toString()}");
    } catch (exception) {
      EasyLoading.dismiss();
      EasyLoading.showToast("Error : ${exception.toString()}");
      print(exception.toString());
    }
  }
}
