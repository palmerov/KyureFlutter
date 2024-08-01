import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/presentation/pages/account_list/account_list_page.dart';
import 'package:kyure/presentation/widgets/atoms/any_image.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';
import 'package:kyure/utils/extensions.dart';
import 'package:kyure/utils/extensions_classes.dart';

import '../account_list_bloc.dart';

extension AccountListViewExtension on AccountListView{
  void showSortDialog(BuildContext context) {
    final bloc = BlocProvider.of<AccountListPageBloc>(context);
    context.showOptionListDialog('Ordenamiento', const SizedBox.shrink(), [
      Option('Nombre: A -> Z', const Icon(Icons.sort_by_alpha_rounded), () {
        bloc.sort(SortBy.nameDesc);
        context.pop();
      }),
      Option('Nombre: Z -> A', const Icon(Icons.sort_by_alpha_rounded), () {
        bloc.sort(SortBy.nameAsc);
        context.pop();
      }),
      Option('Creación: reciente -> anterior', const Icon(Icons.sort_rounded),
              () {
            bloc.sort(SortBy.modifDateDesc);
            context.pop();
          }),
      Option('Creación: anterior -> reciente', const Icon(Icons.sort_rounded),
              () {
            bloc.sort(SortBy.modifDateAsc);
            context.pop();
          }),
    ]);
  }

  showGroupContextMenuDialog(
      AccountListPageBloc bloc, BuildContext context, AccountGroup group) {
    context
        .showOptionListDialog(group.name, SvgIcon(svgAsset: group.iconName), [
      Option('Editar', const Icon(Icons.edit_outlined), () async {
        context.pop();
        final edited = await context.pushNamed(KyRoutes.groupEditor.name,
            queryParameters: {'id': '${group.id}'});
        if (edited != null && (edited as bool)) {
          bloc.reload(true);
        }
      }),
      Option('Eliminar', const Icon(CupertinoIcons.delete), () {
        context.pop();
        context.showYesOrNoDialog('Eliminar grupo',
            'Si eliminas el grupo, se perderán todas las cuentas vinculadas. ¿Deseas eliminarlo?',
                () {
              bloc.deleteGroup(group);
              return true;
            });
      }),
    ]);
  }

  showAccountContextMenuDialog(
      AccountListPageBloc bloc, BuildContext context, Account account) {
    context.showOptionListDialog(
        account.name,
        ImageRounded(
            radius: 8,
            image: AnyImage(
                source: AnyImageSource.fromJson(account.image.source.toJson()),
                image: account.image.path),
            size: 24),
        [
          Option('Editar', const Icon(Icons.edit), () {
            context.pop();
            openAccountDetails(bloc, context, account, true);
          }),
          Option('Eliminar', const Icon(CupertinoIcons.delete), () {
            context.pop();
            context.showYesOrNoDialog('Eliminar cuenta',
                'Estás a punto de eliminar la cuenta "${account.name}".', () {
                  bloc.deleteAccount(account);
                  return true;
                }, () => true, 'Eliminar', 'Conservar');
          }),
        ]);
  }

  openAccountDetails(AccountListPageBloc bloc, BuildContext context,
      Account account, bool editting) async {
    final updated = await context.pushNamed(KyRoutes.accountEditor.name,
        queryParameters: {'id': '${account.id}', 'editting': '$editting'});
    if (updated != null) {
      bloc.reload(true);
    }
  }
}