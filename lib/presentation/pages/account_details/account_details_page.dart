import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/presentation/pages/account_details/bloc/account_details_bloc.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/atoms/any_image.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';
import 'package:kyure/presentation/widgets/organisms/account_form_data.dart';
import 'package:kyure/presentation/widgets/organisms/global_image_selector.dart';
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
  _AccountDetailsView({super.key, required Account account}) {
    tecName = TextEditingController(text: account.name);
  }
  late final TextEditingController tecName;
  final GlobalKey<AnimatedListState> keyFormAnimatedList = GlobalKey();
  final GlobalKey<FormFieldState> keyNameField = GlobalKey();
  final GlobalKey<AccountFormDataOrganismState> keyAccountForm = GlobalKey();
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey();

  _showImageSelectorBottomSheet(
      AccountDetailsBloc bloc, BuildContext context) async {
    showModalBottomSheet(
        context: _keyScaffold.currentContext!,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.76, minHeight: MediaQuery.of(context).size.height * 0.76),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (context) => GlobalImageSelectorOrganism(
          image: bloc.accountCopy!.image,
          onImageSelected: (imagePath, source) {
            context.pop();
            bloc.selectImage(imagePath, source);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    final kytheme = KyTheme.of(context)!;
    final bloc = BlocProvider.of<AccountDetailsBloc>(context);
    final wsize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        context.pop(bloc.accountCopy != null);
        return false;
      },
      child: Scaffold(
        key: _keyScaffold,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  kytheme.light ? Brightness.dark : Brightness.light),
          leading: IconButton(
              onPressed: () => context.pop(bloc.accountCopy != null),
              icon: Icon(CupertinoIcons.back,
                  color: kytheme.colorOnBackgroundOpacity50)),
          title: Text(
            'Detalles de cuenta',
            style: TextStyle(color: kytheme.colorOnBackground),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          if (bloc.state.editting) {
                            _showImageSelectorBottomSheet(bloc, context);
                          }
                        },
                        child: Hero(
                          tag: '@${bloc.account.id}:${bloc.account.name}',
                          child: ImageRounded(
                              size: 98,
                              radius: 12,
                              image: BlocBuilder<AccountDetailsBloc,
                                  AccountDetailsState>(
                                bloc: bloc,
                                buildWhen: (previous, current) =>
                                    previous.imagePath != current.imagePath ||
                                    previous.imageSource != current.imageSource,
                                builder: (context, state) {
                                  return AnyImage(
                                      source: AnyImageSource.fromJson(
                                          state.imageSource.toJson()),
                                      image: state.imagePath);
                                },
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child:
                          BlocBuilder<AccountDetailsBloc, AccountDetailsState>(
                        buildWhen: (previous, current) =>
                            previous.editting != current.editting,
                        builder: (context, state) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 48,
                                child: TextFormField(
                                  key: keyNameField,
                                  controller: tecName,
                                  readOnly: !state.editting,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El nombre no puede estar vacío';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      isDense: true,
                                      label: Text('Nombre del sitio'),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)))),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 36,
                                child: PopupMenuButton(
                                  enabled: state.editting,
                                  onSelected: (value) =>
                                      bloc.selectGroup(value),
                                  offset: const Offset(0, 36),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  itemBuilder: (context) {
                                    return serviceLocator
                                        .getKiureService()
                                        .getRealGroups()
                                        .map((e) => PopupMenuItem(
                                            value: e,
                                            height: 44,
                                            child: SizedBox(
                                              height: 44,
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
                                        radius: 12,
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
                      key: keyAccountForm,
                      keyList: keyFormAnimatedList,
                      onAccountDelete: (index) {
                        bloc.accountCopy!.fieldList!.removeAt(index);
                      },
                      account:
                          state.editting ? bloc.accountCopy! : bloc.account,
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
                                final field = AccountField(
                                    name: 'Nombre del campo',
                                    data: '',
                                    visible: false);
                                bloc.accountCopy!.fieldList!.add(field);
                                keyAccountForm.currentState?.addField(field);
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
                                    SizedBox(width: 12),
                                    Text('Agregar campo'),
                                  ],
                                ),
                              )),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)))),
                            onPressed: () {
                              if (editting) {
                                if (keyNameField.currentState?.validate() ??
                                    false) {
                                  bloc.save(
                                      tecName.text,
                                      keyAccountForm.currentState!
                                          .getAccountFields());
                                }
                              } else {
                                bloc.edit();
                              }
                            },
                            icon: Icon(editting ? Icons.save : Icons.edit),
                            label:
                                Text(editting ? 'Guardar cambios' : 'Editar')),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
