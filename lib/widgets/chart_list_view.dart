import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/models/chat_model.dart';
import 'package:flutter_chat_demo/widgets/chat_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartList extends StatefulWidget {
  const ChartList(
      {Key? key, required this.allChartsData, required this.senderImage})
      : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> allChartsData;
  final String senderImage;

  @override
  State<ChartList> createState() => _ChartListState();
}

class _ChartListState extends State<ChartList> {
  late List<ChatModel> allchats = [];

  @override
  void initState() {
    super.initState();
    sortData();
  }

  sortData() {
    allchats.clear();
    for (var element in widget.allChartsData) {
      allchats.add(
        ChatModel.fromMap(element.data()),
      );
    }
    //sort chats
    allchats.sort(
        (a, b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)));
  }

  @override
  void didUpdateWidget(covariant ChartList oldWidget) {
    if (oldWidget.allChartsData != widget.allChartsData) {
      sortData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return ChatComponent(
            chatData: allchats[index],
            senderImage: widget.senderImage,
            userImage: FirebaseAuth.instance.currentUser?.photoURL ??
                "https://cdn.pixabay.com/photo/2014/04/02/10/54/person-304893_960_720.png",
          );
        },
        separatorBuilder: (_, __) => SizedBox(
              height: 8.h,
            ),
        itemCount: allchats.length);
  }
}
