import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

makeToast({required BuildContext ctx, required String msg}) {
  log(msg);
  showToast(
    msg,
    context: ctx,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.black87,
  );
}
