import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/presentation/pages/lock_page/lock_page_bloc.dart';
import 'package:kyure/presentation/widgets/organisms/key_form.dart';

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
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    'assets/app_icons/kiure_icon_name_dark.png',
                    width: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, top: 12, bottom: 8),
                    child: Text(
                      'Asegura tus cuentas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.6)),
                    ),
                  )
                ]));
          }
          return Stack(
            children: [
              Positioned.fill(
                  child: Image.asset(
                'assets/backgrounds/tarde.jpg',
                fit: BoxFit.cover,
              )),
              const Positioned.fill(
                  child: Blur(
                blurColor: Colors.transparent,
                child: SizedBox.expand(),
              )),
              Positioned.fill(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: BlocConsumer<LockPageBloc, LockPageState>(
                  listenWhen: (previous, current) =>
                      previous != current && current is LockPageLoginState,
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
                        Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Image.asset(
                              'assets/app_icons/kiure_icon_name_dark.png',
                              width: 90,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 32, right: 32, top: 12, bottom: 8),
                              child: Text(
                                'Kyure es una aplicación para guardar tus contraseñas de forma segura.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.6)),
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<LockPageBloc, LockPageState>(
                            builder: (context, state) {
                          if (state is LockPageCreatingVaultState) {
                            if (state.valid) {
                              return KeyFormOrganism(
                                title: 'Crea una llave para tu bóveda',
                                obscureText: false,
                                onTapEnter: (key) async {
                                  final error = await bloc.createNewVault(key);
                                  return error;
                                },
                              );
                            } else {
                              return VaultCreationName(
                                  vaultNameController: _vaultNameController,
                                  bloc: bloc);
                            }
                          }
                          if (state is LockMessageState) {
                            return LockMessage(
                                bloc: bloc, message: state.message);
                          }
                          return LockView(
                              bloc: bloc, vaultNames: state.vaultNames);
                        }),
                      ],
                    );
                  },
                ),
              ))
            ],
          );
        },
      ),
    );
  }
}

class LockView extends StatelessWidget {
  const LockView({
    super.key,
    required this.bloc,
    required this.vaultNames,
  });

  final List<String> vaultNames;
  final LockPageBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              if (vaultNames.isEmpty)
                Column(
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
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OptionButton(
                      icon: const Icon(CupertinoIcons.folder,
                          color: Colors.white),
                      text: 'Importar archivo',
                      onTap: () {
                        bloc.pickFile();
                      }),
                  const SizedBox(width: 8),
                  OptionButton(
                      icon: const Icon(CupertinoIcons.add, color: Colors.white),
                      text: 'Crear nueva bóveda',
                      onTap: () async {
                        bloc.createVault();
                      }),
                ],
              )
            ],
          ),
        ),
        if (vaultNames.isNotEmpty)
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Selecciona una bóveda:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 8),
                BlocBuilder<LockPageBloc, LockPageState>(
                  buildWhen: (previous, current) =>
                      previous != current &&
                      previous.selectedVault != current.selectedVault,
                  builder: (context, state) {
                    return PopupMenuButton(
                      offset: const Offset(0, 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      itemBuilder: (context) {
                        return state.vaultNames
                            .map((e) => PopupMenuItem(
                                    child: ListTile(
                                  title: Text(e),
                                  onTap: () {
                                    bloc.selectVault(e);
                                    context.pop();
                                  },
                                )))
                            .toList();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.selectedVault ?? 'Bóveda',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8))),
                            const SizedBox(width: 8),
                            Icon(CupertinoIcons.chevron_down,
                                size: 16, color: Colors.white.withOpacity(0.8)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: KeyFormOrganism(
                    obscureText: true,
                    onTapEnter: (key) async {
                      final error = await bloc.openVault(key);
                      return error;
                    },
                  ),
                ),
              ],
            ),
          ),
      ]),
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
    return SizedBox(
      width: 100,
      height: 90,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 8),
                Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, color: Colors.white.withOpacity(0.8))),
              ],
            )),
      ),
    );
  }
}
