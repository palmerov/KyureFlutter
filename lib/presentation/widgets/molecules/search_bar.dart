import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class SearchBarMolecule extends StatefulWidget {
  const SearchBarMolecule(
      {super.key, required this.onSearchChanged, this.hintText, required this.onLeadingTap});
  final Function(String text) onSearchChanged;
  final Function() onLeadingTap;
  final String? hintText;
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
      height: 42,
      child: SearchBar(
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: kyTheme.searchViewRadius)),
        elevation: const MaterialStatePropertyAll(0),
        hintText: widget.hintText ?? 'Filter',
        hintStyle:
            MaterialStatePropertyAll(TextStyle(color: kyTheme.colorHint)),
        side: MaterialStatePropertyAll(
            BorderSide(width: 1, color: kyTheme.colorSeparatorLine)),
        onChanged: changedText,
        controller: textEditingController,
        trailing: [
          Padding(
              padding: const EdgeInsets.all(4),
              child: text.isEmpty
                  ? Icon(Icons.search, color: kyTheme.colorHint)
                  : InkWell(
                      onTap: () => changedText(''),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Icon(
                        Icons.close_rounded,
                        color: kyTheme.colorHint,
                      ),
                    ))
        ],
        leading: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
              borderRadius: kyTheme.searchViewRadius,
              onTap: widget.onLeadingTap,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.menu_rounded, color: kyTheme.colorHint),
              )),
        ),
      ),
    );
  }
}
