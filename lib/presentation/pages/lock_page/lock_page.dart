import 'dart:io';

import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/presentation/pages/lock_page/lock_page_bloc.dart';

class LockPage extends StatelessWidget {
  const LockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LockPageBloc()..loadPrefs(),
      child: const _LockView(),
    );
  }
}

class _LockView extends StatelessWidget {
  const _LockView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LockPageBloc>(context);
    return Scaffold(
      body: Stack(
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
              child: BlocConsumer<LockPageBloc, LockPageState>(
                  listenWhen: (previous, current) =>
                      previous != current && current is LockPageLogin,
                  listener: (context, state) =>
                      context.pushNamed(KyRoutes.main.name),
                  buildWhen: (previous, current) =>
                      previous != current &&
                      previous.runtimeType != current.runtimeType &&
                      current is! LockPageLogin,
                  builder: (context, state) {
                    if (state is LockInsertFileState) {
                      return const _InsertFileView();
                    } else if (state is LockInsertKeyState) {
                      return _InsertKeyView(state.createKey);
                    } else {
                      return const SizedBox();
                    }
                  }))
        ],
      ),
    );
  }
}

class _InsertFileView extends StatelessWidget {
  const _InsertFileView();

  @override
  Widget build(BuildContext context) {
    final LockPageBloc bloc = BlocProvider.of<LockPageBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            'No se ha encontrado un archivo de cuentas.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () async {
              await bloc.pickFile();
            },
            icon: const Icon(CupertinoIcons.folder),
            label: const Text('Seleccionar archivo'),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              await bloc.createFile();
            },
            icon: const Icon(CupertinoIcons.add),
            label: const Text('Crear nuevo archivo'),
          ),
        ],
      ),
    );
  }
}

class _InsertKeyView extends StatefulWidget {
  const _InsertKeyView(this.createKey);
  final bool createKey;

  @override
  State<_InsertKeyView> createState() => _InsertKeyViewState();
}

class _InsertKeyViewState extends State<_InsertKeyView> {
  bool keyboard = false;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.createKey
                ? 'Inserte la nueva llave de cifrado'
                : 'Inserte la llave de cifrado',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          BlocBuilder<LockPageBloc, LockPageState>(
            buildWhen: (previous, current) =>
                previous != current &&
                current is LockInsertKeyState &&
                current.error,
            builder: (context, state) {
              if (state is LockInsertKeyState && state.error) {
                return Text(
                  'Error, clave de cifrado incorrecta',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red.shade200, fontSize: 14),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              canRequestFocus: keyboard,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() => keyboard = !keyboard),
                    child: Icon(
                      keyboard
                          ? CupertinoIcons.keyboard
                          : CupertinoIcons.number,
                      color: Colors.white,
                    ),
                  ),
                ),
                hintText: 'Llave de cifrado',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 60, crossAxisCount: 3),
              itemBuilder: (context, index) {
                if (index < 9) {
                  return SizedBox(
                    height: 20,
                    child: InkWell(
                      onTap: () => controller.text += '${index + 1}',
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  );
                } else {
                  if (index == 9) {
                    return InkWell(
                      onTap: () {
                        if (controller.text.isNotEmpty) {
                          controller.text = controller.text
                              .substring(0, controller.text.length - 1);
                        }
                      },
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.delete_left_fill,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (index == 10) {
                    return InkWell(
                      onTap: () => controller.text += '${0}',
                      child: const Center(
                        child: Text(
                          '0',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    );
                  }
                  if (index == 11) {
                    return InkWell(
                      onTap: () => context
                          .read<LockPageBloc>()
                          .initWithKey(controller.text, widget.createKey),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.check_mark,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                }
              },
              itemCount: 12,
            ),
          )
        ],
      ),
    );
  }
}
