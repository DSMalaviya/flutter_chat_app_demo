import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/loader.dart';
import 'package:flutter_chat_demo/providers/auth_provider.dart';
import 'package:flutter_chat_demo/screens/auth_screen.dart';
import 'package:flutter_chat_demo/screens/chat_screen_second.dart';
import 'package:flutter_chat_demo/utils/custom_future_builder.dart';
import 'package:flutter_chat_demo/utils/firestore_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ChatScreenFirst extends StatefulWidget {
  const ChatScreenFirst({Key? key}) : super(key: key);

  static const String routeName = "chatScreenFirst";

  @override
  State<ChatScreenFirst> createState() => _ChatScreenFirstState();
}

class _ChatScreenFirstState extends State<ChatScreenFirst> {
  void signOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }

  onChatTap(Map<String, dynamic> userdata) async {
    late String chatId;
    if (userdata['${FirebaseAuth.instance.currentUser?.uid}'] == null) {
      showProgress(context);
      chatId = await FireStoreHelper.getInstance.generateChatId(
          userdata['userId'], FirebaseAuth.instance.currentUser?.uid ?? "");
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      setState(() {
        userdataFuture = FireStoreHelper.getInstance
            .getUserData(context.read<AuthProvider>().userEmail ?? "");
      });
    } else {
      chatId = userdata['${FirebaseAuth.instance.currentUser?.uid}'];
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushNamed(ChatScreenSecond.routeName, arguments: {
      "email": userdata['userEmail'],
      "profile_img": userdata['userImageUrl'],
      "chatId": chatId
    });
    // FireStoreHelper.getInstance.generateChatId(
    //     userdata['userId'],
    //     FirebaseAuth.instance.currentUser?.uid ?? "");
  }

  late Future<QuerySnapshot> userdataFuture = FireStoreHelper.getInstance
      .getUserData(context.read<AuthProvider>().userEmail ?? "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(1.sw, 55.h),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "Chat App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: signOut,
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 30.h,
              ),
            )
          ],
        ),
      ),
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: CustomFutureBuilder<QuerySnapshot>(
          onData: (_, data) {
            return SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: ListView.separated(
                padding: EdgeInsets.only(top: 10.h),
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  Map<String, dynamic> userdata =
                      data!.docs[index].data() as Map<String, dynamic>;
                  return SizedBox(
                    height: 60.h,
                    width: 1.sw,
                    child: ListTile(
                      onTap: () {
                        onChatTap(userdata);
                      },
                      title: SizedBox(
                        width: .5.sw,
                        child: Text(
                          userdata['userEmail'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                      leading: SizedBox(
                        height: 30.h,
                        width: 30.h,
                        child: CachedNetworkImage(
                          imageUrl: userdata['userImageUrl'],
                          fit: BoxFit.fill,
                          imageBuilder: (_, imageProvider) => CircleAvatar(
                              radius: 15.h, backgroundImage: imageProvider),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: data!.docs.length,
              ),
            );
          },
          onError: (_, error) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          onWait: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          future: userdataFuture,
        ),
      ),
    );
  }
}
