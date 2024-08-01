import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/data/models/sync_result.dart';
import 'package:kyure/data/utils/dialog_utils.dart';
import 'package:kyure/presentation/pages/account_list/account_list_bloc.dart';
import 'package:kyure/presentation/pages/account_list/account_list_page.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';
import 'package:kyure/services/version/vault_version_system_service.dart';

extension AccountListListenerExtension on AccountListView {
  void listenToBloc(BuildContext context, AccountListPageBloc bloc,
      AccountListPageState state) async {
    final kyTheme = KyTheme.of(context)!;
    if (state.alertMessage != null) {
      context.showQuickAlertDialog(state.alertMessage!);
    }
    if (state is AccountListSyncResult) {
      switch (state.result.type) {
        case SyncResultType.success:
          Icon icon;
          String message;
          switch (state.result.direction) {
            case UpdateDirection.toRemote:
              icon = const Icon(Icons.cloud_done_outlined, color: Colors.blue);
              message = 'Cuentas actualizadas en la nube';
              break;
            case UpdateDirection.toLocal:
              icon = const Icon(Icons.mobile_friendly_outlined,
                  color: Colors.blue);
              message = 'Cuentas actualizadas en el dispositivo';
              break;
            case UpdateDirection.toBoth:
              icon = const Icon(Icons.sync, color: Colors.blue);
              message = 'Cuentas sincronizadas';
              break;
            case UpdateDirection.none:
              icon = const Icon(Icons.done, color: Colors.green);
              message = 'Las cuentas ya están actualizadas';
              break;
          }

          BotToast.showCustomText(
              duration: const Duration(seconds: 3),
              toastBuilder: (cancelFunc) => ToastWidgetMolecule(
                  text: message,
                  prefix: icon,
                  backgroundColor: kyTheme.colorToastBackground,
                  textStyle: TextStyle(color: kyTheme.colorToastText)));
          break;
        case SyncResultType.incompatible:
        case SyncResultType.accessError:
          BotToast.showCustomText(
              toastBuilder: (cancelFunc) => ToastWidgetMolecule(
                  text: state.message,
                  prefix: const Icon(Icons.error_outline, color: Colors.red),
                  backgroundColor: kyTheme.colorToastBackground,
                  textStyle: TextStyle(color: kyTheme.colorToastText)));
          break;
        case SyncResultType.wrongRemoteKey:
          final keyResolver =
              await context.push(KyRoutes.keyConflictResolver.routePath);
          if (keyResolver != null) {
            bloc.syncVault(keyResolver as KeyConflictResolver);
          }
          break;
      }
    }
  }
}
