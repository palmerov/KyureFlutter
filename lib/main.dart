import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/services/service_locator.dart';

void main() async {
  serviceLocator.registerAll();
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.getKiureService().initPrefs();
  bool light = serviceLocator.getKiureService().brigtnessLight;
  runApp(MyApp(light: light));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.light});
  final bool light;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApplicationBloc(light),
      child: BlocBuilder<ApplicationBloc, ApplicationState>(
        builder: (context, state) {
          return KyTheme(
            theme: state.light ? KyTheme.lightTheme : KyTheme.darkTheme,
            child: MaterialApp.router(
              title: 'Flutter Demo',
              builder: BotToastInit(),
              theme: state.light ? KyTheme.lightTheme : KyTheme.darkTheme,
              routerConfig: routerConfig,
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}

class ApplicationBloc extends Cubit<ApplicationState> {
  ApplicationBloc(bool light) : super(ApplicationState(light: light));

  toogleTheme() {
    emit(ApplicationState(light: !state.light));
    serviceLocator.getKiureService().brigtnessLight = state.light;
  }
}

class ApplicationState extends Equatable {
  const ApplicationState({required this.light});
  final bool light;

  @override
  List<Object?> get props => [light];
}
