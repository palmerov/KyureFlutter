import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/blured_bottom_app_bar/bottom_item_action.dart';

class BluredBottomAppBarMolecule extends StatelessWidget {
  const BluredBottomAppBarMolecule({super.key, required this.items});
  final List<BottomItemActionMolecule> items;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return SizedBox(
        height: 60,
        child: Stack(children: [
          Positioned.fill(
            child: Blur(
              colorOpacity: kyTheme.blurOpacity,
              blurColor: kyTheme.colorBackground,
              child: const SizedBox.shrink(),
            ),
          ),
          Positioned.fill(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(children: items)))
        ]));
  }
}
