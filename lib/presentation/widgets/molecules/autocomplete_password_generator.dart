import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_password_generator/random_password_generator.dart';

import '../../theme/ky_theme.dart';

class AutocompletePasswordGenerator extends StatelessWidget {
  final AutocompleteFieldViewBuilder fieldViewBuilder;
  final Function(String password) onPasswordGenerated;
  final RandomPasswordGenerator passwordGenerator = RandomPasswordGenerator();

  AutocompletePasswordGenerator(
      {super.key,
      required this.fieldViewBuilder,
      required this.onPasswordGenerated});

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return Autocomplete<String>(
      optionsViewBuilder: (context, Function(String) onSelected, options) {
        if (options.isEmpty) return const SizedBox.shrink();
        return Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: SizedBox(
                width: 280,
                child: Material(
                  child: InkWell(
                    onTap: () => onSelected(options.first),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.lock,
                              size: 20, color: kyTheme.colorPassword),
                          const SizedBox(width: 8),
                          Text(options.first,
                              style: TextStyle(
                                  fontSize: 16, color: kyTheme.colorPassword)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
      },
      fieldViewBuilder: fieldViewBuilder,
      optionsBuilder: (textEditingValue) =>
          textEditingValue.text.isEmpty ? ['Generar contraseña segura'] : [],
      onSelected: (option) {
        final text = passwordGenerator.randomPassword(
            letters: true,
            numbers: true,
            specialChar: true,
            uppercase: true,
            passwordLength: 16);
        onPasswordGenerated(text);
      },
    );
  }
}
