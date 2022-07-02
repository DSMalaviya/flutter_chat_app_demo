import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_demo/models/chat_model.dart';
import 'package:flutter_chat_demo/screens/view_full_img.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatComponent extends StatelessWidget {
  const ChatComponent(
      {Key? key,
      required this.chatData,
      required this.senderImage,
      required this.userImage})
      : super(key: key);

  final ChatModel chatData;
  final String senderImage;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    bool ismine = chatData.from == FirebaseAuth.instance.currentUser?.email;
    return Row(
      mainAxisAlignment:
          ismine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          alignment: ismine ? Alignment.centerRight : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment:
                ismine ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!ismine)
                UserAvatar(
                    ismine: ismine,
                    userImage: userImage,
                    senderImage: senderImage),
              if (!ismine)
                SizedBox(
                  width: 10.w,
                ),
              SizedBox(
                width: .6.sw,
                child: Align(
                  alignment:
                      ismine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: ismine
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatData.from,
                        maxLines: 1,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      if (chatData.type == 1)
                        Text(
                          chatData.content,
                          maxLines: 100,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      if (chatData.type == 2)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ViewFullImage(imgLink: chatData.content),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 90.h,
                              width: 200.w,
                              child: Hero(
                                tag: chatData.content,
                                child: CachedNetworkImage(
                                  imageUrl: chatData.content,
                                  fit: BoxFit.fill,
                                  placeholder: (_, __) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              if (ismine)
                SizedBox(
                  width: 10.w,
                ),
              if (ismine)
                UserAvatar(
                    ismine: ismine,
                    userImage: userImage,
                    senderImage: senderImage)
            ],
          ),
        ),
      ],
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    required this.ismine,
    required this.userImage,
    required this.senderImage,
  }) : super(key: key);

  final bool ismine;
  final String userImage;
  final String senderImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      width: 25.h,
      child: CachedNetworkImage(
        imageUrl: ismine ? userImage : senderImage,
        fit: BoxFit.fill,
        imageBuilder: (_, imageProvider) =>
            CircleAvatar(radius: 15.h, backgroundImage: imageProvider),
      ),
    );
  }
}
