import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_demo/constants/colors.dart';
import 'package:flutter_chat_demo/providers/auth_provider.dart';
import 'package:flutter_chat_demo/screens/auth_screen.dart';
import 'package:flutter_chat_demo/screens/chat_screen_first.dart';
import 'package:flutter_chat_demo/screens/chat_screen_second.dart';
import 'package:flutter_chat_demo/screens/register_screen.dart';
import 'package:flutter_chat_demo/screens/splash_screen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  //await FirebaseAuth.instance.signOut();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (_, __) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
              // primaryColor: greenColor,
              colorSchemeSeed: greenColor,
              fontFamily: "OpenSans",
              scaffoldBackgroundColor: whiteColor),
          initialRoute: SplashScreen.routeName,
          onGenerateRoute: (settings) {
            Map<String, dynamic>? args =
                settings.arguments as Map<String, dynamic>?;
            switch (settings.name) {
              case AuthScreen.routeName:
                return CupertinoPageRoute(
                  builder: (context) => const AuthScreen(),
                  settings: const RouteSettings(name: AuthScreen.routeName),
                );
              case SplashScreen.routeName:
                return CupertinoPageRoute(
                  builder: (context) => const SplashScreen(),
                  settings: const RouteSettings(name: SplashScreen.routeName),
                );
              case ChatScreenFirst.routeName:
                return CupertinoPageRoute(
                  builder: (context) => const ChatScreenFirst(),
                  settings:
                      const RouteSettings(name: ChatScreenFirst.routeName),
                );
              case ChatScreenSecond.routeName:
                return CupertinoPageRoute(
                  builder: (context) => ChatScreenSecond(
                    email: args?['email'] ?? "",
                    profileImg: args?['profile_img'] ?? "",
                    chatId: args?['chatId'] ?? "",
                  ),
                  settings:
                      const RouteSettings(name: ChatScreenSecond.routeName),
                );
              case RegisterScreen.routeName:
                return CupertinoPageRoute(
                  builder: (context) => const RegisterScreen(),
                  settings: const RouteSettings(name: RegisterScreen.routeName),
                );
              default:
            }
          },
        ),
      ),
    );
  }
}
//https://www.figma.com/file/uCjdJaBfqK7NjZcABybU08/WhatsUp---Chatting-App-UI-Kit-(Community)?node-id=0%3A1