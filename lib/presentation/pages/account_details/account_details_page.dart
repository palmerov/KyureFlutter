import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/pages/account_details/bloc/account_details_bloc.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';
import 'package:kyure/presentation/widgets/organisms/account_form_data.dart';
import 'package:kyure/services/service_locator.dart';

class AccountDetailsPage extends StatelessWidget {
  const AccountDetailsPage({
    Key? key,
    required this.account,
    required this.editing,
    required this.group,
  }) : super(key: key);
  final bool editing;
  final Account account;
  final AccountGroup group;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountDetailsBloc(account: account, group: group, editting: editing),
      child: _AccountDetailsView(
        account: account,
      ),
    );
  }
}

class _AccountDetailsView extends StatelessWidget {
  _AccountDetailsView({super.key, required this.account}) {
    tecName = TextEditingController(text: account.name);
  }
  final Account account;
  late final TextEditingController tecName;
  final GlobalKey<AnimatedListState> keyFormAnimatedList = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final kytheme = KyTheme.of(context)!;
    final bloc = BlocProvider.of<AccountDetailsBloc>(context);
    final wsize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: kytheme.colorBackground,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(CupertinoIcons.back,
                color: kytheme.colorOnBackgroundOpacity50)),
        title: Text(
          'Detalles de cuenta',
          style: TextStyle(color: kytheme.colorOnBackground),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {},
                      child: Hero(
                        tag: '@${account.id}:${account.name}',
                        child: ImageRounded(
                            size: 98,
                            radius: 12,
                            image: Image.asset(
                              account.image?.path ??
                                  'assets/web_icons/squared.png',
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BlocBuilder<AccountDetailsBloc, AccountDetailsState>(
                      buildWhen: (previous, current) =>
                          previous.editting != current.editting,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: tecName,
                              readOnly: !state.editting,
                              decoration: const InputDecoration(
                                  alignLabelWithHint: true,
                                  isDense: true,
                                  label: Text('Nombre del sitio'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 36,
                              child: PopupMenuButton(
                                enabled: state.editting,
                                onSelected: (value) => bloc.selectGroup(value),
                                offset: const Offset(0, 36),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                itemBuilder: (context) {
                                  return serviceLocator
                                      .getUserDataService()
                                      .accountsData!
                                      .accountGroups
                                      .map((e) => PopupMenuItem(
                                          value: e,
                                          height: 36,
                                          child: SizedBox(
                                            height: 36,
                                            width: 140,
                                            child: Row(children: [
                                              SvgIcon(svgAsset: e.iconName),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Text(e.name),
                                            ]),
                                          )))
                                      .toList();
                                },
                                child: BlocBuilder<AccountDetailsBloc,
                                    AccountDetailsState>(
                                  buildWhen: (previous, current) =>
                                      previous.selectedGroup.name !=
                                      current.selectedGroup.name,
                                  builder: (context, state) {
                                    return AccountGroupMolecule(
                                      icon: SvgIcon(
                                          svgAsset:
                                              state.selectedGroup.iconName),
                                      text: state.selectedGroup.name,
                                      color: state.editting
                                          ? Color(state.selectedGroup.color)
                                          : kytheme.colorSeparatorLine,
                                      paddingHorizontal: 0,
                                      selected: true,
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<AccountDetailsBloc, AccountDetailsState>(
                buildWhen: (previous, current) =>
                    previous.editting != current.editting,
                builder: (context, state) {
                  return Expanded(
                      child: AccountFormDataOrganism(
                    keyList: keyFormAnimatedList,
                    onAccountDelete: (index) {
                      bloc.accountCopy!.fieldList!.removeAt(index);
                    },
                    account: state.editting ? bloc.accountCopy! : account,
                    editting: state.editting,
                  ));
                },
              ),
              const SizedBox(
                height: 8,
              ),
              BlocBuilder<AccountDetailsBloc, AccountDetailsState>(
                buildWhen: (previous, current) =>
                    previous.editting != current.editting,
                builder: (context, state) {
                  final editting = state.editting;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (editting)
                        OutlinedButton(
                            onPressed: () {
                              bloc.accountCopy!.fieldList ??= [];
                              bloc.accountCopy!.fieldList!.add(AccountField(
                                  name: 'Nombre del campo', data: ''));
                              keyFormAnimatedList.currentState!.insertItem(
                                  (bloc.accountCopy!.fieldList!.length - 1) +
                                      2);
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: kytheme.colorSeparatorLine,
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(12)))),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text('Agregar campo'),
                                ],
                              ),
                            )),
                      FilledButton.icon(
                          onPressed: () => editting ? bloc.save() : bloc.edit(),
                          icon: Icon(editting ? Icons.save : Icons.edit),
                          label: Text(editting ? 'Guardar cambios' : 'Editar')),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
