import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class AnyImage extends StatelessWidget {
  const AnyImage({
    super.key,
    required this.source,
    required this.image,
    this.height,
    this.width,
    this.alignment,
    this.fit,
  });
  final Alignment? alignment;
  final BoxFit? fit;
  final AnyImageSource source;
  final String image;
  final double? height, width;

  isSvg(bool deep) {
    if (deep) {
      for (int i = image.length - 1; i >= 0; i--) {
        if (image[i] == '.') {
          return image.substring(i + 1).toLowerCase().startsWith('svg');
        }
      }
    }
    return image.toLowerCase().endsWith('.svg');
  }

  isPixeledImage() {
    return image.toLowerCase().endsWith('.png') ||
        image.toLowerCase().endsWith('.jpg') ||
        image.toLowerCase().endsWith('.jpeg') ||
        image.toLowerCase().endsWith('.gif') ||
        image.toLowerCase().endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    return switch (source) {
      AnyImageSource.assets => isSvg(false)
          ? SvgPicture.asset(image,
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.cover)
          : Image.asset(image,
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.cover),
      AnyImageSource.file => isSvg(false)
          ? SvgPicture.file(File(image),
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.cover)
          : Image.file(File(image),
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.cover),
      AnyImageSource.svgString => SvgPicture.string(image,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center),
      AnyImageSource.network => isSvg(false) || isPixeledImage()
          ? CachedNetworkImage(
              imageUrl: image,
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholder: (context, url) => Shimmer(
                  gradient: RadialGradient(
                      colors: [Colors.grey.shade200, Colors.grey.shade300]),
                  child: SizedBox(
                    height: height,
                    width: width,
                  )))
          : CachedNetworkSVGImage(
              image,
              alignment: alignment ?? Alignment.center,
              fit: fit ?? BoxFit.cover,
              placeholder: Shimmer(
                  gradient: RadialGradient(
                      colors: [Colors.grey.shade200, Colors.grey.shade300]),
                  child: SizedBox(
                    height: height,
                    width: width,
                  )),
            ),
    };
  }
}

enum AnyImageSource {
  assets,
  network,
  file,
  svgString;

  factory AnyImageSource.fromJson(String json) {
    switch (json) {
      case 'assets':
        return AnyImageSource.assets;
      case 'network':
        return AnyImageSource.network;
      case 'file':
        return AnyImageSource.file;
      case 'svgString':
        return AnyImageSource.svgString;
    }
    return AnyImageSource.assets;
  }

  String toJson() {
    switch (this) {
      case AnyImageSource.assets:
        return 'assets';
      case AnyImageSource.network:
        return 'network';
      case AnyImageSource.file:
        return 'file';
      case AnyImageSource.svgString:
        return 'svgString';
    }
  }
}
