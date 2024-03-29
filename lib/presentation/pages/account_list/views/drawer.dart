import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router_config.dart';
import '../../../../main.dart';
import '../../../../services/service_locator.dart';
import '../../../theme/ky_theme.dart';
import '../../../widgets/molecules/context_menu_tile.dart';
import '../account_list_bloc.dart';
import '../account_list_page.dart';

class KiureDrawer extends StatelessWidget {
  const KiureDrawer({
    super.key,
    required this.isPcScreen,
    this.width,
  });

  final bool isPcScreen;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    final appBloc = context.read<ApplicationBloc>();
    final listBloc = BlocProvider.of<AccountListPageBloc>(context);
    return NavigationDrawer(
      elevation: isPcScreen ? 2 : 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24, top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => appBloc.toogleTheme(),
                child: Icon(appBloc.state.light
                    ? CupertinoIcons.sun_max
                    : CupertinoIcons.moon),
              )
            ],
          ),
        ),
        SizedBox(
          height: 116,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  appBloc.state.light
                      ? 'assets/app_icons/kiure_icon_name_light.png'
                      : 'assets/app_icons/kiure_icon_name_dark.png',
                  width: 100,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('Asegura tus cuentas'),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        _buildDrawerItem(
            kyTheme: kyTheme,
            onTap: () => context.pushNamed(KyRoutes.keyEditor.name),
            label: 'Cambiar clave',
            icon: const Icon(CupertinoIcons.lock)),
        _buildDrawerItem(
            kyTheme: kyTheme,
            onTap: () => listBloc.syncWithFile(),
            label: 'Sincronizar con archivo',
            icon: const Icon(CupertinoIcons.arrow_down_doc)),
        _buildDrawerItem(
            kyTheme: kyTheme,
            label: 'Exportar bóveda',
            icon: const Icon(CupertinoIcons.share),
            onTap: () async {
              String path =
                  await context.read<AccountListPageBloc>().exportFile();
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    content: Text(
                        'Tu archivo de cuentas ha sido exportado a: $path'),
                    actions: [
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Copiar directorio'),
                        ),
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: File(path).parent.path));
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Compartir'),
                        ),
                        onTap: () {
                          shareFile(path, 'Cuentas Kiure',
                              'Archivo Encriptado de cuentas de Kiure');
                        },
                      )
                    ],
                  ),
                );
              }
            }),
        _buildDrawerItem(
          kyTheme: kyTheme,
          label: 'Eliminar bóveda',
          icon: const Icon(CupertinoIcons.delete),
          onTap: () {
            _showDeleteVaultConfirmDialog(context);
          },
        ),
        _buildDrawerItem(
            kyTheme: kyTheme,
            label: 'Donar :)',
            icon: const Icon(CupertinoIcons.heart),
            onTap: () {}),
      ],
    );
  }

  ContextMenuTileMolecule _buildDrawerItem(
      {required KyTheme kyTheme,
      required String label,
      required Widget icon,
      required Function() onTap}) {
    return ContextMenuTileMolecule(
        onTap: onTap,
        label: label,
        textStyle: TextStyle(color: kyTheme.colorOnBackground, fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        separation: 16,
        icon: icon);
  }

  void _showDeleteVaultConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Eliminar Bóveda',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Si eliminas la bóveda, se perderán todas las cuentas y grupos. ¿Deseas eliminarla?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        context.pop();
                        serviceLocator.getVaultService().deleteVault(false);
                        context.goNamed(KyRoutes.lockPage.name,
                            queryParameters: {'blockedByUser': 'true'});
                      },
                      child: const Text('Si')),
                ],
              )
            ],
          )),
    );
  }
}
