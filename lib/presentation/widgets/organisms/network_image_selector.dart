import 'package:flutter/material.dart';
import 'package:kyure/presentation/widgets/atoms/any_image.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';

class NetworkImageSelectorOrganism extends StatefulWidget {
  const NetworkImageSelectorOrganism(
      {super.key,
      required this.onImageSelected,
      required this.onLocalImageTap});
  final Function(String imagePath, bool selected) onImageSelected;
  final Function() onLocalImageTap;

  @override
  State<NetworkImageSelectorOrganism> createState() =>
      _NetworkImageSelectorOrganismState();
}

class _NetworkImageSelectorOrganismState
    extends State<NetworkImageSelectorOrganism> {
  String? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageRounded(
            size: 140,
            radius: 12,
            image: AnyImage(
              source: image != null
                  ? AnyImageSource.network
                  : AnyImageSource.assets,
              image: image ?? 'assets/web_icons/squared.png',
              height: 140,
              width: 140,
              fit: BoxFit.contain,
            )),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'URL de la imagen',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          onChanged: (value) => setState(() => image = value),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)))),
            icon: const Icon(Icons.image),
            label: const Text('Imágenes locales'),
            onPressed: widget.onLocalImageTap),
        OutlinedButton.icon(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)))),
            icon: const Icon(Icons.close),
            label: const Text('Cancelar'),
            onPressed: () => widget.onImageSelected('', false)),
        FilledButton.icon(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)))),
            icon: const Icon(Icons.check),
            label: const Text('Seleccionar'),
            onPressed: () => widget.onImageSelected(image ?? '', true)),
      ],
    );
  }
}
