import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/atoms/any_image.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/organisms/asset_image_selector.dart';

class GlobalImageSelectorOrganism extends StatefulWidget {
  const GlobalImageSelectorOrganism(
      {super.key, required this.onImageSelected, required this.image});
  final Function(String imagePath, ImageSource imageSource) onImageSelected;
  final AccountImage image;

  @override
  State<GlobalImageSelectorOrganism> createState() =>
      _GlobalImageSelectorOrganismState();
}

class _GlobalImageSelectorOrganismState
    extends State<GlobalImageSelectorOrganism> {
  String? path;
  ImageSource? imageSource;
  List<String>? assetImages;
  late TextEditingController textEdController;

  @override
  void initState() {
    super.initState();
    path = widget.image.path;
    imageSource = widget.image.source;
    textEdController = TextEditingController(
        text: (widget.image.source == ImageSource.network)
            ? widget.image.path
            : '');
    initAssetImages();
  }

  initAssetImages() async {
    final json =
        jsonDecode(await rootBundle.loadString('assets/web_icons.json'));
    setState(() {
      assetImages = json['icons'].cast<String>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    final wsize = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: wsize.height * 0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              GestureDetector(
                  onTap: () => context.pop(), child: const Icon(Icons.close))
            ]),
            const Text('Selecciona una imagen',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (assetImages != null)
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kyTheme.colorSeparatorLine)),
                  child: AssetImageSelectorOrganism(
                      assetImages: assetImages!,
                      onAssetImageSelected: (assetImage) => setState(() {
                            textEdController!.text = '';
                            imageSource = ImageSource.assets;
                            path = assetImage;
                          })),
                ),
              ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 84),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                ImageRounded(
                    size: 64,
                    radius: 12,
                    image: AnyImage(
                      source: AnyImageSource.fromJson(imageSource!.toJson()),
                      image: path!,
                      height: 64,
                      width: 64,
                      fit: BoxFit.contain,
                    )),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    canRequestFocus: false,
                    controller: textEdController,
                    maxLines: 2,
                    minLines: 2,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: 'Inserta una URL de imagen',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                                onTap: () async {
                                  textEdController.text =
                                      (await ClipboardUtils.paste()) ?? '';
                                  setState(() {
                                    imageSource = ImageSource.network;
                                    path = textEdController.text;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('Pegar',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ],
                        ),
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    onChanged: (value) => setState(() {
                      imageSource = ImageSource.network;
                      path = value;
                    }),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)))),
                icon: const Icon(Icons.check),
                label: const Text('Seleccionar'),
                onPressed: () {
                  widget.onImageSelected(path!, imageSource!);
                }),
          ],
        ),
      ),
    );
  }
}