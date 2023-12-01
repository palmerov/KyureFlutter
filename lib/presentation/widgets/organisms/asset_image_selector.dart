import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class AssetImageSelectorOrganism extends StatefulWidget {
  const AssetImageSelectorOrganism({super.key, this.onAssetImageSelected});
  final Function(String assetImage)? onAssetImageSelected;

  @override
  State<AssetImageSelectorOrganism> createState() =>
      _AssetImageSelectorOrganismState();
}

class _AssetImageSelectorOrganismState
    extends State<AssetImageSelectorOrganism> {
  List<String>? assetImages;

  @override
  void initState() {
    super.initState();
    _loadAssetImages();
  }

  _loadAssetImages() async {
    final json =
        jsonDecode(await rootBundle.loadString('assets/web_icons.json'));
    assetImages = json['icons'].cast<String>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: assetImages == null
            ? GridView.builder(
                itemCount: 50,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: Shimmer(
                        gradient: LinearGradient(colors: [
                          Colors.grey,
                          Colors.grey.withOpacity(0.5)
                        ]),
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                  );
                },
              )
            : GridView.builder(
              physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, assetImages![index]);
                          widget.onAssetImageSelected!(assetImages![index]);
                        },
                        child: Image.asset(assetImages![index])),
                  );
                },
                itemCount: assetImages!.length,
              ));
  }
}
