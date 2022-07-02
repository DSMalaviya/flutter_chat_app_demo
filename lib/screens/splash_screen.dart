import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/colors.dart';
import 'package:flutter_chat_demo/providers/auth_provider.dart';
import 'package:flutter_chat_demo/screens/auth_screen.dart';
import 'package:flutter_chat_demo/screens/chat_screen_first.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = "SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400)).then((_) {
      //user is not authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      } else {
        context.read<AuthProvider>().setAuthData(
            userId: user.uid,
            userName: user.displayName ?? "",
            userImage: user.photoURL ??
                "https://cdn.pixabay.com/photo/2014/04/02/10/54/person-304893_960_720.png",
            email: user.email ?? "");
        Navigator.of(context).pushReplacementNamed(ChatScreenFirst.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              height: 120.h,
              width: 120.h,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.fill,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 30.h,
              width: 30.h,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                color: greenColor,
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
          ],
        ),
      ),
    );
  }
}
