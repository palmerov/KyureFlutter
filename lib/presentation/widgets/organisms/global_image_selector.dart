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
  final Function(String imagePath, ImageSourceType imageSourceType)
      onImageSelected;
  final ImageSource image;

  @override
  State<GlobalImageSelectorOrganism> createState() =>
      _GlobalImageSelectorOrganismState();
}

class _GlobalImageSelectorOrganismState
    extends State<GlobalImageSelectorOrganism> {
  String? path;
  ImageSourceType? imageSourceType;
  List<String>? assetImages;
  late TextEditingController textEdController;

  @override
  void initState() {
    super.initState();
    path = widget.image.data;
    imageSourceType = widget.image.source;
    textEdController = TextEditingController(
        text: (widget.image.source == ImageSourceType.network)
            ? widget.image.data
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 84),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ImageRounded(
                  size: 54,
                  radius: 12,
                  image: AnyImage(
                    source: AnyImageSource.fromJson(imageSourceType!.toJson()),
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
                                  imageSourceType = ImageSourceType.network;
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
                    imageSourceType = ImageSourceType.network;
                    path = value;
                  }),
                ),
              ),
            ]),
          ),
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
                          textEdController.text = '';
                          imageSourceType = ImageSourceType.asset;
                          path = assetImage;
                          widget.onImageSelected(path!, imageSourceType!);
                        })),
              ),
            ),
          const SizedBox(height: 8),
          FilledButton.icon(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)))),
              icon: const Icon(Icons.check),
              label: const Text('Seleccionar'),
              onPressed: () {
                widget.onImageSelected(path!, imageSourceType!);
              }),
        ],
      ),
    );
  }
}
