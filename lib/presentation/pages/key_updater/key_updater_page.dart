import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/presentation/theme/ky_backgrounds.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';
import 'package:kyure/presentation/widgets/organisms/key_form.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/utils/extensions.dart';

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
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(CupertinoIcons.back, color: Colors.white)),
            title: const Text('Cambiar llave de cifrado',
                style: TextStyle(color: Colors.white))),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(child: KyBackgrounds.gradientSunset),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/app_icons/kiure_icon_name_light.png',
                                  width: 100,
                                  height: 50),
                              const SizedBox(height: 16),
                              const Text(
                                  'IMPORTANTE:\nSi tienes configurada una nube, tendrás que insertar la clave antigua al sincronizar los datos, así que, segúrate de guardar la clave antigua.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 16)),
                            ])),
                    const SizedBox(height: 8),
                    KeyFormOrganism(
                        obscureText: false,
                        onBackgroundColor: Colors.white,
                        onTapEnter: (key) async {
                          if (key.length < 6) {
                            return Text(
                                'La clave debe tener al menos 6 caracteres',
                                style: TextStyle(color: kTheme.colorError));
                          }

                          serviceLocator.getVaultService().updateKey(key);

                          Future.delayed(const Duration(milliseconds: 500), () {
                            context.showYesOrNoDialog('Llave actualizada',
                                'La llave de cifrado de esta bóveda ha sido actualizada con éxito.',
                                () {
                              Future.delayed(const Duration(milliseconds: 200),
                                  () => context.pop());
                              return true;
                            }, () => true, 'Entendido', null);
                          });

                          return const Text('La llave se ha cambiado con éxito',
                              style: TextStyle(color: Colors.greenAccent));
                        },
                        title:
                            'Inserta la nueva llave de cifrado. Asegúrate de recordarla bien.'),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
