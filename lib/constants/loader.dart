import 'package:flutter/material.dart';

showProgress(BuildContext ctx) {
  return showDialog(
    context: ctx,
    barrierDismissible: false,
    builder: (ctx) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}
