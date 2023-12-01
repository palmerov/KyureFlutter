import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class SearchBarMolecule extends StatefulWidget {
  const SearchBarMolecule(
      {super.key,
      required this.onSearchChanged,
      this.hintText,
      required this.onLeadingTap,
      required this.enabled,
      required this.showLeading});
  final Function(String text) onSearchChanged;
  final Function() onLeadingTap;
  final String? hintText;
  final bool enabled;
  final bool showLeading;
  @override
  State<SearchBarMolecule> createState() => _SearchBarMoleculeState();
}

class _SearchBarMoleculeState extends State<SearchBarMolecule> {
  String text = '';
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  changedText(String currentText) {
    if (currentText != text) {
      setState(() {
        textEditingController.text = currentText;
        text = currentText;
        widget.onSearchChanged(currentText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return SizedBox(
      height: 44,
      child: Container(
        decoration: BoxDecoration(
            color: kyTheme.colorBackground,
            shape: BoxShape.rectangle,
            borderRadius: kyTheme.searchViewRadius,
            border: Border.all(
                color: kyTheme.colorOnBackgroundOpacity30,
                width: kyTheme.borderWidth05)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.showLeading)
              Padding(
                  padding: const EdgeInsets.only(right: 8, left: 12),
                  child: InkWell(
                      borderRadius: kyTheme.searchViewRadius,
                      onTap: widget.enabled ? widget.onLeadingTap : null,
                      child:
                          Icon(Icons.menu_rounded, color: kyTheme.colorHint))),
            if (!widget.showLeading)
              const SizedBox(
                width: 16,
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: TextField(
                  enabled: widget.enabled,
                  expands: false,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: widget.hintText ?? 'Filter',
                  ),
                  onChanged: changedText,
                  controller: textEditingController,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 12),
                child: text.isEmpty
                    ? Icon(Icons.search, color: kyTheme.colorHint)
                    : InkWell(
                        onTap: widget.enabled ? () => changedText('') : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Icon(
                          Icons.close_rounded,
                          color: kyTheme.colorHint,
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
