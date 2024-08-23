import 'package:flutter/material.dart';

class ImageRounded extends StatelessWidget {
  const ImageRounded({super.key, required this.image, this.size, this.radius, this.border});
  final Widget image;
  final double? size;
  final double? radius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 8))),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: size ?? 42,
        height: size ?? 42,
        child: image,
      ),
    );
  }
}
