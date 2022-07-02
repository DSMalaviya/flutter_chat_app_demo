import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/colors.dart';
import 'package:flutter_chat_demo/constants/loader.dart';

import 'package:flutter_chat_demo/utils/firestore_helper.dart';
import 'package:flutter_chat_demo/utils/imagepicker_fun.dart';
import 'package:flutter_chat_demo/widgets/chart_list_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreenSecond extends StatefulWidget {
  const ChatScreenSecond(
      {Key? key,
      required this.email,
      required this.profileImg,
      required this.chatId})
      : super(key: key);

  static const String routeName = "/chatScreenSecond";

  final String email;
  final String profileImg;
  final String chatId;

  @override
  State<ChatScreenSecond> createState() => _ChatScreenSecondState();
}

class _ChatScreenSecondState extends State<ChatScreenSecond> {
  late final TextEditingController chatController = TextEditingController();

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream =
      FireStoreHelper.getInstance.getStreamOfChats(chatId: widget.chatId);

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  addChat() {
    String content = chatController.text.trim();
    if (content != "") {
      // FocusScope.of(context).unfocus();
      FireStoreHelper.getInstance.addChat(
          chatId: widget.chatId,
          from: FirebaseAuth.instance.currentUser?.email ?? "",
          to: widget.email,
          content: content);
      chatController.text = "";
    }
  }

  sendImage() {
    imgPickFunction(
        callback: (String imagePath) async {
          showProgress(context);
          await FireStoreHelper.getInstance.addPicture(
              chatId: widget.chatId,
              from: FirebaseAuth.instance.currentUser?.email ?? "",
              to: widget.email,
              filePath: imagePath);
          if (!mounted) {
            return;
          }
          Navigator.of(context).pop();
        },
        ctx: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(1.sw, 55.h),
        child: AppBar(
          centerTitle: true,
          title: Text(
            widget.email,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //chat area
            Expanded(
              child: SizedBox(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  builder: (context, snapshot) {
                    //waiting case
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    //data case
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      log("build");
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          allChartsData = snapshot.data!.docs;

                      return ChartList(
                        allChartsData: allChartsData,
                        senderImage: widget.profileImg,
                      );
                    }

                    //error case
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    //empty sized box if no data
                    return const SizedBox();
                  },
                  stream: _stream,
                ),
              ),
            ),
            //bootom chat btn
            SizedBox(
              width: 1.sw - 30.w,
              height: 45.h,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: Colors.grey.withOpacity(.5), width: 1.sp),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: sendImage,
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: greenColor,
                              size: 20.h,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: chatController,
                              cursorColor: greenColor,
                              maxLines: 1,
                              minLines: 1,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: "Type Something...",
                                hintStyle: TextStyle(fontSize: 14.5.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  GestureDetector(
                    onTap: addChat,
                    child: Container(
                      height: 45.h,
                      width: 45.h,
                      decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 25.h,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
