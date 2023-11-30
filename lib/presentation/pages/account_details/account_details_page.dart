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
  }) : super(key: key);
  final bool editing;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountDetailsBloc(),
      child: _AccountDetailsView(
        editing: editing,
        account: account,
      ),
    );
  }
}

class _AccountDetailsView extends StatelessWidget {
  _AccountDetailsView(
      {super.key, required this.editing, required this.account}) {
    tecName = TextEditingController(text: account.name);
  }
  final bool editing;
  final Account account;
  late final TextEditingController tecName;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    final bloc = BlocProvider.of<AccountDetailsBloc>(context);
    final wsize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: kyTheme.colorBackground,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(CupertinoIcons.back,
                color: kyTheme.colorOnBackgroundOpacity50)),
        title: Text(
          'Detalles de cuenta',
          style: TextStyle(color: kyTheme.colorOnBackground),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: kyTheme.colorOnBackgroundOpacity50),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: InkWell(
                      onTap: () {},
                      child: Hero(
                        tag: '@${account.id}:${account.name}',
                        child: ImageRounded(
                            size: 86,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: tecName,
                          decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              isDense: true,
                              label: Text('Nombre del sitio'),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 36,
                          child: PopupMenuButton(
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
                                      svgAsset: state.selectedGroup.iconName),
                                  text: state.selectedGroup.name,
                                  color: Color(state.selectedGroup.color),
                                  paddingHorizontal: 0,
                                  selected: true,
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              AccountFormDataOrganism(account: account, editting: false,)
            ],
          ),
        ),
      ),
    );
  }
}
