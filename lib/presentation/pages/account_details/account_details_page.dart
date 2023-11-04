import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';

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
    return _AccountDetailsView(
      editing: editing,
      account: account,
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
          padding: const EdgeInsets.all(12),
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
                            const BorderRadius.all(Radius.circular(16))),
                    child: InkWell(
                      onTap: () {},
                      child: Hero(
                        tag: '@${account.id}:${account.name}',
                        child: ImageRounded(
                            size: 82,
                            radius: 14,
                            image: Image.asset(
                              account.image!.path,
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                                      BorderRadius.all(Radius.circular(16)))),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 34,
                          child: AccountGroupMolecule(
                            icon: const SvgIcon(
                                svgAsset: 'assets/svg_icons/widgets.svg'),
                            text: 'Variados',
                            color: Colors.blue,
                            onTap: () {},
                            paddingHorizontal: 0,
                            selected: false,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
