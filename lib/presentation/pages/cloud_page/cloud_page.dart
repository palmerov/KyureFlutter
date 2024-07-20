import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cloud_bloc.dart';

class CloudPage extends StatelessWidget {
  const CloudPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CloudSettingsCubit(), child: CloudView());
  }
}

class CloudView extends StatelessWidget {
  CloudView({super.key});

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CloudSettingsCubit>();
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Text('Configurar nube')),
        body: BlocConsumer<CloudSettingsCubit, CloudSettingsState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error!),
                duration: const Duration(minutes: 2),
              ));
            }
          },
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(CupertinoIcons.cloud,
                        size: 60,
                        color: bloc.isAuthorized()
                            ? Colors.blue
                            : Colors.grey),
                    const SizedBox(height: 16),
                    if (state.settings == null)
                      const Text(
                        'Configura tu nube para sincronizar tus datos de forma segura entre dispositivos.',
                        textAlign: TextAlign.center,
                      ),
                    if (bloc.isAuthorized())
                      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          'Nube configurada',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.check, color: Colors.green),
                      ]),
                    const SizedBox(height: 16),
                    if (state.settings == null)
                      Text(
                        state.waitingForToken
                            ? 'Insertar token de autorización'
                            : 'Proveedor configurado: ninguno',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 16),
                    if (state.waitingForToken)
                      TextFormField(
                          controller: _textController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    Clipboard.getData('text/plain')
                                        .then((value) {
                                      _textController.text = value!.text!;
                                    });
                                  },
                                  icon: const Icon(Icons.paste)),
                              labelText: 'Token de autorización',
                              hintText: 'Inserta el token de autorización',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))))),
                    const SizedBox(height: 16),
                    if (!state.waitingForToken) ...[
                      FilledButton(
                          onPressed: () => bloc.startWithDropBox(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.gear),
                              const SizedBox(width: 8),
                              Text(state.settings == null
                                  ? 'Configurar DropBox'
                                  : 'Reconfigurar DropBox'),
                            ],
                          ))
                    ],
                    if (state.waitingForToken) ...[
                      FilledButton(
                          onPressed: () {
                            bloc.setupDropBoxToken(_textController.text);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.done),
                              SizedBox(width: 8),
                              Text('Guardar'),
                            ],
                          ))
                    ],
                  ]),
            );
          },
        ));
  }
}
