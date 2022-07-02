import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/custom_toast.dart';
import 'package:flutter_chat_demo/constants/loader.dart';
import 'package:flutter_chat_demo/constants/validator_functions.dart';
import 'package:flutter_chat_demo/providers/auth_provider.dart';
import 'package:flutter_chat_demo/screens/chat_screen_first.dart';
import 'package:flutter_chat_demo/screens/register_screen.dart';
import 'package:flutter_chat_demo/utils/firestore_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const String routeName = "/authScreen";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passWordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    emailController.dispose();
    passWordController.dispose();
    super.dispose();
  }

  Future<void> signinUseingPassword(String email, String pass) async {
    try {
      showProgress(context);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
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

  Future<void> signInUsingGoogle() async {
    try {
      showProgress(context);
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      //add data to firestore
      await FireStoreHelper.getInstance.addUserData(
          userEmail: userCredential.user?.email ?? "",
          userId: userCredential.user?.uid ?? "",
          userImageUrl: userCredential.user?.photoURL ??
              "https://cdn.pixabay.com/photo/2014/04/02/10/54/person-304893_960_720.png");

      if (!mounted) {
        return;
      }
      context.read<AuthProvider>().setAuthData(
            userId: userCredential.user?.uid ?? "",
            userName: userCredential.user?.displayName ?? "",
            userImage: userCredential.user?.photoURL ??
                "https://cdn.pixabay.com/photo/2014/04/02/10/54/person-304893_960_720.png",
            email: userCredential.user?.email ?? "",
          );
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(ChatScreenFirst.routeName);
    } catch (e) {
      Navigator.of(context).pop();
      makeToast(ctx: context, msg: e.toString());
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
                  "Login",
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
                      return null;
                    }),
                    decoration: const InputDecoration(
                      label: Text("Enter Password"),
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        signinUseingPassword(
                            emailController.text, passWordController.text);
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                SizedBox(
                  height: 50.h,
                  width: 1.sw - 60.w,
                  child: ElevatedButton(
                    onPressed: signInUsingGoogle,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.blue),
                    ),
                    child: Text(
                      "Login with Google",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RegisterScreen.routeName);
                  },
                  child: Text(
                    "Don't Have An Account? Register",
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
