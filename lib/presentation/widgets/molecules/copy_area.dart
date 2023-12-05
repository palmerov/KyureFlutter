import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class CopyAreaMolecule extends StatefulWidget {
  const CopyAreaMolecule(
      {super.key,
      required this.icon,
      required this.color,
      this.onTap,
      this.padding = const EdgeInsets.all(8),
      this.showBorder = true,
      this.iconSize = 30,
      this.animate = true,
      this.animateToIcon});
  final Widget icon;
  final Widget? animateToIcon;
  final bool animate;
  final Color color;
  final EdgeInsets padding;
  final bool showBorder;
  final Function(TapDownDetails details)? onTap;
  final double iconSize;

  @override
  State<CopyAreaMolecule> createState() => _CopyAreaMoleculeState();
}

class _CopyAreaMoleculeState extends State<CopyAreaMolecule> {
  Widget? icon;
  bool copied = false;

  setCopiedState() async {
    if (!widget.animate) return;
    if (copied) return;
    copied = true;
    if (mounted) {
      setState(() {
        icon = widget.icon.animate().fadeOut(duration: 50.ms).swap(
            builder: (context, child) {
          return SizedBox(
            height: widget.iconSize,
            width: widget.iconSize,
            child: widget.animateToIcon ??
                SvgPicture.asset('assets/svg_icons/copy_checked.svg',
                        height: widget.iconSize,
                        width: widget.iconSize,
                        colorFilter:
                            ColorFilter.mode(widget.color, BlendMode.srcIn))
                    .animate(effects: [
                  FadeEffect(duration: 200.ms),
                  ScaleEffect(duration: 200.ms, curve: Curves.elasticOut)
                ]),
          );
        });
      });
      await Future.delayed(20.seconds);
      copied = false;
      if (mounted) {
        setState(() {
          icon = SizedBox(
            height: widget.iconSize,
            width: widget.iconSize,
            child: widget.animateToIcon ??
                SvgPicture.asset('assets/svg_icons/copy_checked.svg',
                        height: widget.iconSize,
                        width: widget.iconSize,
                        colorFilter:
                            ColorFilter.mode(widget.color, BlendMode.srcIn))
                    .animate()
                    .fadeOut(duration: 200.ms)
                    .swap(
                        builder: (context, child) =>
                            widget.icon.animate(effects: [
                              FadeEffect(duration: 200.ms),
                            ])),
          );
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
              ? Border.all(color: kyTheme.colorSeparatorLine, width: 0.7)
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTapDown: (TapDownDetails details) {
            setCopiedState();
            if (widget.onTap != null) widget.onTap!(details);
          },
          child: SizedBox(
            height:
                widget.iconSize + widget.padding.left + widget.padding.right,
            width: widget.iconSize + widget.padding.top + widget.padding.bottom,
            child: Padding(
              padding: widget.padding,
              child: icon ?? widget.icon,
            ),
          )),
    );
  }
}
