import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/utils/extensions_classes.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../presentation/widgets/molecules/context_menu_tile.dart';

extension BuildContextDialogExtension on BuildContext {
  showYesOrNoDialog(String title, String message, bool Function() onYes,
      [bool Function()? onNo, String yesText = 'Sí', String? noText = 'No']) {
    showDialog(
      context: this,
      useSafeArea: true,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (noText != null)
                    TextButton(
                        onPressed: () {
                          if (onNo == null || onNo()) {
                            pop();
                          }
                        },
                        child: Text(noText)),
                  TextButton(
                      onPressed: () {
                        if (onYes()) {
                          pop();
                        }
                      },
                      child: Text(yesText)),
                ],
              )
            ],
          )),
    );
  }

  showOptionListDialog(String title, Widget icon, List<Option> options) {
    showDialog(
        context: this,
        useSafeArea: true,
        builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      icon,
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(title,
                              style: const TextStyle(fontSize: 18))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...options.map((option) => ContextMenuTileMolecule(
                        onTap: option.onTap,
                        label: option.title,
                        icon: option.icon,
                      ))
                ])));
  }

  showQRDialog(String qrData,
      [String title = 'Escanear QR', bool showDataBelow = false]) {
    if(qrData.isEmpty) return;
    Size size = MediaQuery.of(this).size;
    final double qrSize = min(size.width * 0.8, 260);
    showDialog(
      context: this,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              const Icon(Icons.qr_code_scanner),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18))
            ]),
            const SizedBox(height: 16),
            Container(
                width: qrSize + 4,
                height: qrSize + 4,
                color: Colors.white,
                child: QrImageView(
                    data: qrData,
                    padding: const EdgeInsets.all(0),
                    size: qrSize)),
            if (showDataBelow) ...[
              const SizedBox(height: 8),
              Text(qrData, style: const TextStyle(fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis)
            ],
            const SizedBox(height: 16),
            TextButton(onPressed: () => pop(), child: const Text('Cerrar'))
          ],
        ),
      ),
    );
  }
}
