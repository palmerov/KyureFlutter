import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/main.dart';
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
  const AccountDetailsPage(
      {Key? key, required this.account, required this.editing})
      : super(key: key);
  final bool editing;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountDetailsBloc(account: account, editting: editing),
      child: _AccountDetailsView(
        account: account,
      ),
    );
  }
}

class _AccountDetailsView extends StatelessWidget {
  _AccountDetailsView({required Account account}) {
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
          title: Text('Detalles de cuenta',
              style: TextStyle(color: kytheme.colorOnBackground)),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isPC ? 500 : double.infinity),
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
                                        previous.imageSourceType !=
                                            current.imageSourceType,
                                    builder: (context, state) {
                                      return AnyImage(
                                          source: AnyImageSource.fromJson(
                                              state.imageSourceType.toJson()),
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
                                    height: 50,
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
                                      decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          isDense: true,
                                          label: const Text('Nombre de la cuenta'),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(12)),
                                              borderSide: BorderSide(
                                                  color: kytheme
                                                      .colorOnBackgroundOpacity30)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(12)),
                                              borderSide: BorderSide(
                                                  color: kytheme
                                                      .colorOnBackgroundOpacity50)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kytheme
                                                      .colorOnBackgroundOpacity30),
                                              borderRadius:
                                                  const BorderRadius.all(Radius.circular(12)))),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: PopupMenuButton<AccountGroup>(
                                      enabled: state.editting,
                                      onSelected: (value) =>
                                          bloc.selectGroup(value),
                                      offset: const Offset(0, 36),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                      itemBuilder: (context) {
                                        return serviceLocator
                                            .getVaultService()
                                            .groups!
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
                                            previous.selectedGroup.id !=
                                            current.selectedGroup.id,
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
                      height: 24,
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
                    BlocConsumer<AccountDetailsBloc, AccountDetailsState>(
                      listenWhen: (previous, current) =>
                          current is ErrorSavingState,
                      listener: (context, state) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Ups...'),
                            content: Text((state as ErrorSavingState).error),
                            actions: [
                              TextButton(
                                  onPressed: () => context.pop(),
                                  child: const Text('Seguir editando'))
                            ],
                          ),
                        );
                      },
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
                                        visible: true);
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
                                    Text(editting ? 'Guardar cuenta' : 'Editar')),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
