import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/presentation/pages/group_details/group_details_bloc.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';
import 'package:kyure/presentation/widgets/organisms/asset_image_selector.dart';
import 'package:kyure/services/service_locator.dart';

class GroupDetailsPage extends StatelessWidget {
  const GroupDetailsPage({super.key, required this.group, required this.isNew});
  final AccountGroup group;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupDetailsBloc(group: group, isNew: isNew),
      child: _GroupDetailsView(),
    );
  }
}

class _GroupDetailsView extends StatelessWidget {
  _GroupDetailsView();

  final double imgSize = 64;
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormFieldState> _formKey = GlobalKey();

  _showImageSelectorDialog(GroupDetailsBloc bloc, BuildContext context) async {
    final json =
        jsonDecode(await rootBundle.loadString('assets/svg_icons.json'));
    final assetImages = json['icons'].cast<String>();
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return Container(
            color: KyTheme.of(context)!.colorBackground,
            child: AssetImageSelectorOrganism(
              assetImages: assetImages,
              onAssetImageSelected: (assetImage) {
                bloc.setIconName(assetImage);
              },
            ),
          );
        },
      );
    }
  }

  _showColorPickerDialog(BuildContext context, Color color) async {
    GroupDetailsBloc bloc = BlocProvider.of<GroupDetailsBloc>(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: color,
            onColorChanged: (value) {
              bloc.setColor(value);
              context.pop();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kytheme = KyTheme.of(context)!;
    final bloc = BlocProvider.of<GroupDetailsBloc>(context);
    _nameController.text = bloc.groupCopy.name;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                kytheme.light ? Brightness.dark : Brightness.light),
        leading: IconButton(
            onPressed: () => context.pop(bloc.saved),
            icon: Icon(CupertinoIcons.back,
                color: kytheme.colorOnBackgroundOpacity50)),
        title: Text(
          'Detalles del grupo',
          style: TextStyle(color: kytheme.colorOnBackground),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
                        buildWhen: (previous, current) =>
                            previous.iconName != current.iconName ||
                            previous.color != current.color,
                        builder: (context, state) {
                          return InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            onTap: () =>
                                _showImageSelectorDialog(bloc, context),
                            child: ImageRounded(
                              image: SvgIcon(svgAsset: state.iconName),
                              size: imgSize,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
                        buildWhen: (previous, current) =>
                            previous.color != current.color,
                        builder: (context, state) {
                          return InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              onTap: () =>
                                  _showColorPickerDialog(context, state.color),
                              child: Container(
                                height: imgSize,
                                width: imgSize,
                                decoration: BoxDecoration(
                                    color: state.color,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16))),
                              ));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: _formKey,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre no puede estar vacío';
                      }
                      if (bloc.isNew &&
                          serviceLocator
                                  .getVaultService()
                                  .findGroupByName(_nameController.text) !=
                              null) {
                        return 'Ya existe un grupo con ese nombre';
                      }
                      return null;
                    },
                    onChanged: (value) => bloc.setName(value),
                    decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  )
                ],
              ),
              FilledButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)))),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      bloc.save();
                      context.pop(bloc.saved);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'))
            ],
          ),
        ),
      ),
    );
  }
}
