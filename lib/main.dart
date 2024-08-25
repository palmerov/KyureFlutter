import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:system_tray/system_tray.dart';

void main() async {
  serviceLocator.registerAll();
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator.getKiureService().initPrefs();
  bool light = serviceLocator.getKiureService().brigtnessLight;
  appBloc = ApplicationBloc(light);
  runApp(MyApp(light: light));
  appBloc.restartSystemTry();
}

bool showingWindow = true;

late ApplicationBloc appBloc;

bool get isPC => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool get isMobile => Platform.isAndroid || Platform.isIOS;

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.light});

  final bool light;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: appBloc,
      child: BlocBuilder<ApplicationBloc, ApplicationState>(
        builder: (context, state) {
          return KyTheme(
            theme: state.light ? KyTheme.lightTheme : KyTheme.darkTheme,
            child: MaterialApp.router(
              scrollBehavior: MyScrollBehavior(),
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

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class ApplicationBloc extends Cubit<ApplicationState> {
  ApplicationBloc(bool light) : super(ApplicationState(light: light));

  toogleTheme() {
    emit(ApplicationState(light: !state.light));
    serviceLocator.getKiureService().brigtnessLight = state.light;
  }

  lock() {
    BuildContext? context = kiureNavigatorKey.currentContext;
    if (context != null) {
      context.goNamed(KyRoutes.lockPage.name);
      serviceLocator.getVaultService().closeVault();
    }
  }

  restartSystemTry() async {
    if (isPC) {
      String path = 'assets/app_icons/kiure_icon_tray.png';

      final AppWindow appWindow = AppWindow();
      final SystemTray systemTray = SystemTray();

      // We first init the systray menu
      await systemTray.initSystemTray(
        toolTip: 'Kiure',
        iconPath: path,
      );

      // create context menu
      final Menu menu = Menu();
      await menu.buildFrom([
        MenuItemLabel(
            image: showingWindow
                ? 'assets/app_icons/collapse_tray.png'
                : 'assets/app_icons/open_tray.png',
            label: showingWindow ? 'Minimizar al ícono' : 'Abrir Kiure',
            onClicked: (menuItem) {
              if (showingWindow) {
                appWindow.hide();
              } else {
                appWindow.show();
              }
              showingWindow = !showingWindow;
              restartSystemTry();
            }),
        if (serviceLocator.getVaultService().isOpen)
          MenuItemLabel(
              label: 'Bloquear',
              image: 'assets/app_icons/lock_tray.png',
              onClicked: (_) {
                appBloc.lock();
              }),
        MenuSeparator(),
        ...serviceLocator.getKiureService().vaultRecentAccounts.map((e) =>
            SubMenu(
                label: e.name,
                image: e.image.source == ImageSourceType.asset
                    ? e.image.data
                    : null,
                children: [
                  MenuItemLabel(
                      label: e.fieldUsername.data,
                      onClicked: (menuItem) =>
                          ClipboardUtils.copy(e.fieldUsername.data)),
                  MenuItemLabel(
                      label: '**Contraseña**',
                      onClicked: (menuItem) =>
                          ClipboardUtils.copy(e.fieldPassword.data)),
                ])),
      ]);

      // set context menu
      await systemTray.setContextMenu(menu);

      // handle system tray event
      systemTray.registerSystemTrayEventHandler((eventName) {
        showingWindow = !showingWindow;
        showingWindow ? appWindow.show() : appWindow.hide();
      });
    }
  }
}

class ApplicationState extends Equatable {
  const ApplicationState({required this.light});

  final bool light;

  @override
  List<Object?> get props => [light];
}
