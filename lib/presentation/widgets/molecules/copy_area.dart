import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class CopyAreaMolecule extends StatefulWidget {
  const CopyAreaMolecule(
      {super.key,
      required this.icon,
      required this.color,
      this.onTap,
      this.padding = const EdgeInsets.all(8),
      this.showBorder = true});
  final Widget icon;
  final Color color;
  final EdgeInsets padding;
  final bool showBorder;
  final Function(TapDownDetails details)? onTap;

  @override
  State<CopyAreaMolecule> createState() => _CopyAreaMoleculeState();
}

class _CopyAreaMoleculeState extends State<CopyAreaMolecule> {
  Widget? icon;
  bool copied = false;

  setCopiedState() async {
    if (copied) return;
    copied = true;
    if (mounted) {
      setState(() {
        icon = widget.icon.animate().fadeOut(duration: 50.ms).swap(
            builder: (context, child) {
          return Icon(
            Icons.library_add_check_outlined,
            color: widget.color,
          ).animate(effects: [
            FadeEffect(duration: 200.ms),
            ScaleEffect(duration: 200.ms, curve: Curves.elasticOut)
          ]);
        });
      });
      await Future.delayed(20.seconds);
      copied = false;
      if (mounted) {
        setState(() {
          icon = Icon(
            Icons.library_add_check_outlined,
            color: widget.color,
          ).animate().fadeOut(duration: 200.ms).swap(
              builder: (context, child) => widget.icon.animate(effects: [
                    FadeEffect(duration: 200.ms),
                  ]));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return Container(
      decoration: BoxDecoration(
          border: widget.showBorder
              ? Border.all(color: kyTheme.colorSeparatorLine, width: 1)
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTapDown: (TapDownDetails details) {
            setCopiedState();
            if (widget.onTap != null) widget.onTap!(details);
          },
          child: Padding(
            padding: widget.padding,
            child: icon ?? widget.icon,
          )),
    );
  }
}
