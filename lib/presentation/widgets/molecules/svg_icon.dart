import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({super.key, required this.svgAsset, this.color, this.size});
  final String svgAsset;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgAsset,
      height: size ?? 20,
      width: size ?? 20,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
