import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

imgPickFunction({required Function callback, required BuildContext ctx}) {
  FocusScope.of(ctx).unfocus();
  late final ImagePicker picker = ImagePicker();
  showCupertinoModalPopup(
    context: ctx,
    builder: (context) => CupertinoActionSheet(
      title: const Text("Please Choose option"),
      message: const Text("Please Select Where to Pick image?"),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          child: const Text(
            'Camera',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            Navigator.pop(context);
            XFile? image = await picker.pickImage(
                source: ImageSource.camera, imageQuality: 50);
            if (image != null) {
              callback(image.path);
            }
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            'Gallery',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            Navigator.pop(context);
            XFile? image = await picker.pickImage(
                source: ImageSource.gallery, imageQuality: 50);
            if (image != null) {
              callback(image.path);
            }
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
