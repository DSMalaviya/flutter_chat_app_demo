import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
  String? userId;
  String? userName;
  String? userImage;
  String? userEmail;

  setAuthData(
      {required String userId,
      required String userName,
      required String userImage,
      required String email}) {
    userId = userId;
    userName = userName;
    userImage = userImage;
    userEmail = email;
    notifyListeners();
  }
}
