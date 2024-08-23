import 'dart:math';

import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/main.dart';
import 'package:kyure/presentation/pages/lock_page/lock_page_bloc.dart';
import 'package:kyure/presentation/theme/ky_backgrounds.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/organisms/key_form.dart';
import 'package:kyure/utils/extensions.dart';
import 'package:kyure/utils/extensions_classes.dart';

class LockPage extends StatelessWidget {
  const LockPage({super.key, required this.blockedByUser});

  final bool blockedByUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LockPageBloc(blockedByUser)..initVaultService(),
      child: _LockView(),
    );
  }
}

class _LockView extends StatelessWidget {
  _LockView({super.key});

  final TextEditingController _vaultNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LockPageBloc>(context);
    final ktheme = KyTheme.of(context)!;
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<LockPageBloc, LockPageState>(
            buildWhen: (previous, current) =>
                current is LockPageInitialState ||
                current is LockPageInitialState ||
                current.loaded != previous.loaded,
            builder: (context, state) {
              if (state is LockPageInitialState) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                            'assets/app_icons/kiure_icon_name_dark.png',
                            width: 90),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 32, right: 32, top: 12, bottom: 8),
                          child: Text('Asegura tus cuentas.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.6))))
                    ]);
              }
              return Stack(children: [
                Positioned.fill(child: KyBackgrounds.gradientSunset),
                Positioned.fill(
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: BlocConsumer<LockPageBloc, LockPageState>(
                            listenWhen: (previous, current) =>
                                previous != current &&
                                current is LockPageLoginState,
                            listener: (context, state) =>
                                context.goNamed(KyRoutes.main.name),
                            buildWhen: (previous, current) =>
                                previous.vaultNames != current.vaultNames,
                            builder: (context, state) {
                              return Column(
                                  verticalDirection: VerticalDirection.down,
                                  mainAxisAlignment: state.vaultNames.isNotEmpty
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                          const SizedBox(height: 30),
                                          Image.asset(
                                              'assets/app_icons/kiure_icon_name_dark.png',
                                              width: 60),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 32,
                                                  right: 32,
                                                  top: 12,
                                                  bottom: 8),
                                              child: Text(
                                                  'Kyure es una aplicación para guardar tus cuentas de forma segura.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white
                                                          .withOpacity(0.6))))
                                        ])),
                                    BlocBuilder<LockPageBloc, LockPageState>(
                                        builder: (context, state) {
                                      if (state is LockPageCreatingVaultState) {
                                        if (state.valid) {
                                          return KeyFormOrganism(
                                              title:
                                                  'Crea una llave para tu bóveda',
                                              obscureText: false,
                                              onTapEnter: (key) async {
                                                final error = await bloc
                                                    .createNewVault(key);
                                                return error != null
                                                    ? Text(error,
                                                        style: TextStyle(
                                                            color: ktheme
                                                                .colorError,
                                                            fontSize: 14))
                                                    : null;
                                              });
                                        } else {
                                          return Expanded(
                                              child: VaultCreationName(
                                                  vaultNameController:
                                                      _vaultNameController,
                                                  bloc: bloc));
                                        }
                                      }
                                      if (state is LockMessageState) {
                                        return Expanded(
                                          child: LockMessage(
                                              bloc: bloc,
                                              message: state.message),
                                        );
                                      }
                                      if (state.vaultNames.isEmpty) {
                                        return Expanded(
                                            child:
                                                NotVaultFoundView(bloc: bloc));
                                      }
                                      return VaultSelectorView(
                                          bloc: bloc,
                                          vaultNames: state.vaultNames);
                                    })
                                  ]);
                            })))
              ]);
            }));
  }
}

class VaultSelectorView extends StatelessWidget {
  const VaultSelectorView({
    super.key,
    required this.bloc,
    required this.vaultNames,
  });

  final List<String> vaultNames;
  final LockPageBloc bloc;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final ktheme = KyTheme.of(context)!;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isPC ? 500 : double.infinity),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VaultFileMenu(bloc: bloc),
            BlocBuilder<LockPageBloc, LockPageState>(
                buildWhen: (previous, current) =>
                    previous != current &&
                    previous.selectedVault != current.selectedVault,
                builder: (context, state) {
                  return Column(
                      mainAxisAlignment: state.selectedVault != null
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.center,
                      children: [
                        TextButton(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(CupertinoIcons.cube,
                                          color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                          state.selectedVault ??
                                              'Seleccionar bóveda',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight:
                                                  state.selectedVault != null
                                                      ? FontWeight.normal
                                                      : FontWeight.bold))
                                    ])),
                            onPressed: () => showVaultListDialog(context)),
                        state.selectedVault != null
                            ? KeyFormOrganism(
                                obscureText: true,
                                onTapEnter: (key) async {
                                  final error = await bloc.openVault(key);
                                  return error != null
                                      ? Text(error,
                                          style: TextStyle(
                                              color: ktheme.colorError,
                                              fontSize: 14))
                                      : null;
                                },
                              )
                            : const SizedBox(height: 200)
                      ]);
                })
          ]),
    );
  }

  void showVaultListDialog(BuildContext context) {
    context.showOptionListDialog(
        'Tus bóvedas',
        const SizedBox.shrink(),
        vaultNames
            .map<Option>((e) => Option(e, const Icon(CupertinoIcons.cube), () {
                  bloc.selectVault(e);
                  context.pop();
                }))
            .toList());
  }
}

class NotVaultFoundView extends StatelessWidget {
  const NotVaultFoundView({
    super.key,
    required this.bloc,
  });

  final LockPageBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        const Text(
          'No hay bóvedas creadas',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          'Crea una nueva bóveda o importa una existente',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
        ),
        const SizedBox(height: 24),
        VaultFileMenu(bloc: bloc)
      ],
    );
  }
}

class VaultFileMenu extends StatelessWidget {
  const VaultFileMenu({
    super.key,
    required this.bloc,
  });

  final LockPageBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: OptionButton(
                icon: const Icon(CupertinoIcons.folder, color: Colors.white),
                text: 'Importar archivo',
                onTap: () {
                  bloc.pickFile();
                }),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OptionButton(
                icon: const Icon(CupertinoIcons.add, color: Colors.white),
                text: 'Nueva bóveda',
                onTap: () async {
                  bloc.createVault();
                }),
          ),
        ],
      ),
    );
  }
}

class LockMessage extends StatelessWidget {
  const LockMessage({
    super.key,
    required this.bloc,
    required this.message,
  });

  final LockPageBloc bloc;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade200, fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
          OptionButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
              text: 'Regresar',
              onTap: () async {
                bloc.initVaultService();
              }),
        ],
      ),
    );
  }
}

class VaultCreationName extends StatelessWidget {
  const VaultCreationName({
    super.key,
    required TextEditingController vaultNameController,
    required this.bloc,
  }) : _vaultNameController = vaultNameController;

  final TextEditingController _vaultNameController;
  final LockPageBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: TextFormField(
            controller: _vaultNameController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9 _-áéíóúÁÉÍÓÚ]'))
            ],
            decoration: InputDecoration(
                hintText: 'Nombre de la bóveda',
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.8)),
                    borderRadius: BorderRadius.circular(16)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.8)),
                    borderRadius: BorderRadius.circular(16)),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.8)),
                    borderRadius: BorderRadius.circular(16)),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.8))),
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<LockPageBloc, LockPageState>(
          buildWhen: (previous, current) =>
              previous != current && current is LockPageCreatingVaultState,
          builder: (context, state) {
            if (state is LockPageCreatingVaultState) {
              return Text(
                state.message ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OptionButton(
                icon: const Icon(CupertinoIcons.back, color: Colors.white),
                text: 'Regresar',
                onTap: () async {
                  bloc.initVaultService();
                }),
            const SizedBox(width: 8),
            OptionButton(
                icon:
                    const Icon(CupertinoIcons.check_mark, color: Colors.white),
                text: 'Crear',
                onTap: () async {
                  bloc.validateName(_vaultNameController.text);
                }),
          ],
        ),
      ],
    );
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  final Function() onTap;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
          onPressed: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 8),
              Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Colors.white.withOpacity(0.8))),
            ],
          )),
    );
  }
}
