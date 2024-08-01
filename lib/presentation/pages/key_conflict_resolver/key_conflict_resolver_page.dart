import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/sync_result.dart';
import 'package:kyure/presentation/theme/ky_backgrounds.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/organisms/key_form.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/utils/extensions.dart';
import 'package:kyure/utils/extensions_classes.dart';

class KeyConflictResolverPage extends StatelessWidget {
  const KeyConflictResolverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _KeyConflictResolverView();
  }
}

class _KeyConflictResolverView extends StatelessWidget {
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
            title: const Text('Llave de cifrado remota',
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
                              const Icon(Icons.cloud_outlined,
                                  color: Colors.white, size: 50),
                              const SizedBox(height: 16),
                              const Text(
                                  'Se necesita la llave de cifrado de la bóveda que está en la nube para sincronizar las cuentas.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              const SizedBox(height: 16),
                              TextButton(
                                  onPressed: () {
                                    context.showYesOrNoDialog(
                                        'Sobrescribir bóveda en la nube',
                                        'Si has perdido la llave, habrá que sobrscribir esta bóveda en la nube, por tanto, se perderán esos datos remotos. ¿Quieres hacerlo?',
                                        () {
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        context.pop(KeyConflictResolver(null,
                                            KeyUpdateDirection.toRemote, true));
                                      });
                                      return true;
                                    }, () {
                                      return true;
                                    }, 'Sí, sobrescribir', 'No, cancelar');
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.orangeAccent),
                                      SizedBox(width: 8),
                                      Text('No tango esa llave',
                                          style: TextStyle(
                                              color: Colors.orangeAccent)),
                                    ],
                                  ))
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
                          context.showOptionListDialog(
                              'Seleciona qué llave guardar',
                              const Icon(Icons.key), [
                            Option('Guardar llave remota en local',
                                const Icon(Icons.cloud_download_outlined), () {
                              context.pop();
                              context.pop(KeyConflictResolver(
                                  key, KeyUpdateDirection.toLocal, false));
                            }),
                            Option('Guardar llave local en remoto',
                                const Icon(Icons.cloud_upload_outlined), () {
                              context.pop();
                              context.pop(KeyConflictResolver(
                                  key, KeyUpdateDirection.toRemote, false));
                            })
                          ]);
                          return const Text('Sincronizando...',
                              style: TextStyle(color: Colors.greenAccent));
                        },
                        title: 'Inserta la llave remota'),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
