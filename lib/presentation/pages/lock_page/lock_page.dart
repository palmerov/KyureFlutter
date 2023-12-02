import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/presentation/pages/lock_page/lock_page_bloc.dart';
import 'package:kyure/presentation/widgets/molecules/account_list_shimmer.dart';
import 'package:kyure/presentation/widgets/organisms/key_form.dart';

class LockPage extends StatelessWidget {
  const LockPage({super.key, required this.blockedByUser});
  final bool blockedByUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LockPageBloc(blockedByUser)..loadPrefs(),
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                      context.goNamed(KyRoutes.main.name),
                  buildWhen: (previous, current) =>
                      previous != current &&
                      previous.runtimeType != current.runtimeType &&
                      current is! LockPageLogin,
                  builder: (context, state) {
                    if(state is LockPageLoading){
                      return const AccountListShimmerMolecule();
                    }
                    else if (state is LockInsertFileState) {
                      return const _InsertFileView();
                    } else if (state is LockInsertKeyState) {
                      return KeyFormOrganism(
                        title: state.createKey
                            ? 'Inserte la nueva llave de cifrado'
                            : 'Inserte la llave de cifrado',
                        obscureText: !state.createKey,
                        onTapEnter: (key)async {
                         return await bloc.initWithKey(key, state.createKey);
                        },
                        error: state.error,
                      );
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
