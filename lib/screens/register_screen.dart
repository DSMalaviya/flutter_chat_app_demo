import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/custom_toast.dart';
import 'package:flutter_chat_demo/constants/loader.dart';
import 'package:flutter_chat_demo/constants/validator_functions.dart';
import 'package:flutter_chat_demo/providers/auth_provider.dart';
import 'package:flutter_chat_demo/screens/auth_screen.dart';
import 'package:flutter_chat_demo/screens/chat_screen_first.dart';
import 'package:flutter_chat_demo/utils/firestore_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String routeName = "registerScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passWordController = TextEditingController();
  late TextEditingController cpassWordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    cpassWordController.dispose();
    super.dispose();
  }

  Future<void> signupUseingPassword(String email, String pass) async {
    try {
      showProgress(context);
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      //add data to firestore
      await FireStoreHelper.getInstance.addUserData(
          userEmail: credential.user?.email ?? "",
          userId: credential.user?.uid ?? "",
          userImageUrl: credential.user?.photoURL ??
              "https://cdn.pixabay.com/photo/2014/04/02/10/54/person-304893_960_720.png");

      if (!mounted) {
        return;
      }
      context.read<AuthProvider>().setAuthData(
          userId: credential.user?.uid ?? "",
          userName: credential.user?.displayName ?? "",
          userImage: credential.user?.photoURL ??
              "https://cdn.pixabay.com/photo/2014/04/02/10/54/person-304893_960_720.png",
          email: credential.user?.email ?? "");
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(ChatScreenFirst.routeName);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      if (e.code == 'weak-password') {
        makeToast(ctx: context, msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        makeToast(
            ctx: context, msg: "The account already exists for that email.");
      }
    } catch (e) {
      Navigator.of(context).pop();
      log(e.toString());
      makeToast(
          ctx: context, msg: "Something went wrong please try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Text(
                  "Signup",
                  style:
                      TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.h,
                ),
                SizedBox(
                  width: 1.sw - 60.w,
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: ((value) {
                      if (!isValidEmail(value, isRequired: true)) {
                        return "Please Enter Valid Email";
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      label: Text("Enter Email"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: 1.sw - 60.w,
                  child: TextFormField(
                    controller: passWordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: ((value) {
                      if (!isValidPassword(value, isRequired: true)) {
                        return "Please Enter Valid Password";
                      }
                      if (value != cpassWordController.text) {
                        return "Both password must be same";
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      label: Text("Enter Password"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: 1.sw - 60.w,
                  child: TextFormField(
                    controller: cpassWordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: ((value) {
                      if (!isValidPassword(value, isRequired: true)) {
                        return "Please Enter Valid Password";
                      }
                      if (value != passWordController.text) {
                        return "Both password must be same";
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      label: Text("Confirm Password"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                SizedBox(
                  height: 50.h,
                  width: 1.sw - 60.w,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        signupUseingPassword(
                            emailController.text, passWordController.text);
                      }
                    },
                    child: Text(
                      "Signup",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                  child: Text(
                    "Already Have An Account? Login",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
