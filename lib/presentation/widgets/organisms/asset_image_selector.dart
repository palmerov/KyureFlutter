import 'package:flutter/material.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';

class AssetImageSelectorOrganism extends StatelessWidget {
  const AssetImageSelectorOrganism(
      {super.key, this.onAssetImageSelected, required this.assetImages});
  final Function(String assetImage)? onAssetImageSelected;
  final List<String> assetImages;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, assetImages[index]);
                    onAssetImageSelected!(assetImages[index]);
                  },
                  child: assetImages![index].toLowerCase().endsWith('.svg')
                      ? SvgIcon(svgAsset: assetImages[index])
                      : Image.asset(assetImages[index])),
            );
          },
          itemCount: assetImages!.length,
        ));
  }
}
