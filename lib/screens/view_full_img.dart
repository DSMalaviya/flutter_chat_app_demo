import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewFullImage extends StatelessWidget {
  const ViewFullImage({Key? key, required this.imgLink}) : super(key: key);

  final String imgLink;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
      child: Material(
        color: Colors.white.withOpacity(.5),
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Stack(
            children: [
              Positioned(
                top: 20.h,
                left: 20.w,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    size: 30.h,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: 1.sw - 30.w,
                    child: Hero(
                      tag: imgLink,
                      child: CachedNetworkImage(
                        imageUrl: imgLink,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
