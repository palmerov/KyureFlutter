import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/pages/group_details/group_details_bloc.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';

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
  _GroupDetailsView({super.key});

  final double imgSize = 64;
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final kytheme = KyTheme.of(context)!;
    final bloc = BlocProvider.of<GroupDetailsBloc>(context);
    final wsize = MediaQuery.of(context).size;
    _nameController.text = bloc.group.name;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: kytheme.colorBackground,
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
                            onTap: () {},
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
                              onTap: () {},
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
                    controller: _nameController,
                    onChanged: (value) => bloc.setName(value),
                    decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  )
                ],
              ),
              FilledButton.icon(
                  onPressed: () {
                    bloc.save();
                    context.pop(bloc.saved);
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
