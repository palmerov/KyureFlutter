import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/organisms/key_form.dart';
import 'package:kyure/services/service_locator.dart';

class KeyUpdaterPage extends StatelessWidget {
  const KeyUpdaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _KeyUpdaterView();
  }
}

class _KeyUpdaterView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final kTheme = KyTheme.of(context)!;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: kTheme.colorBackground,
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(CupertinoIcons.back,
                  color: kTheme.colorOnBackgroundOpacity50)),
          title: Text(
            'Cambiar llave de cifrado',
            style: TextStyle(color: kTheme.colorOnBackground),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: SizedBox(height: 200)),
            Expanded(
              child: KeyFormOrganism(
                  obscureText: false,
                  onBackgroundColor: kTheme.colorOnBackground,
                  onTapEnter: (key) async {
                    if (key.length < 8) {
                      return 'La clave debe tener al menos 8 caracteres';
                    }

                    serviceLocator.getVaultService().updateKey(key);
                    return 'La llave se ha cambiado con éxito';
                  },
                  title: 'Inserta la nueva llave de cifrado'),
            ),
            const SizedBox(height: 16)
          ],
        ));
  }
}
