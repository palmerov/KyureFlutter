import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/pages/account_list/account_list_bloc.dart';
import 'package:kyure/presentation/widgets/atoms/list_item_separator.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:kyure/presentation/widgets/molecules/account_group_list_shimmer.dart';
import 'package:kyure/presentation/widgets/molecules/account_item.dart';
import 'package:kyure/presentation/widgets/molecules/account_list_shimmer.dart';
import 'package:kyure/presentation/widgets/molecules/search_bar.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/services/service_locator.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountListPageBloc(serviceLocator.getUserDataService())..load(),
      child: _AccountListView(),
    );
  }
}

class _AccountListView extends StatelessWidget {
  _AccountListView({super.key}) {
    keyScaffold = GlobalKey<ScaffoldState>();
    pageController = PageController();
  }
  late final GlobalKey<ScaffoldState> keyScaffold;
  late final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size;
    final kyTheme = KyTheme.of(context)!;
    AccountListPageBloc bloc = BlocProvider.of<AccountListPageBloc>(context);
    return Scaffold(
      key: keyScaffold,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: kyTheme.colorBackground,
          centerTitle: false,
          leadingWidth: 0,
          titleSpacing: 8,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: BlocBuilder<AccountListPageBloc, AccountListPageState>(
              buildWhen: (previous, current) => previous != current &&
                  previous is AccountListPageStateLoading|| previous is AccountListPageStateInitial,
              builder: (context, state) {
                return SearchBarMolecule(
                  enabled: state is! AccountListPageStateLoading,
                  onSearchChanged: (text) => bloc.filter(text),
                  onLeadingTap: () {
                    keyScaffold.currentState!.openDrawer();
                  },
                );
              },
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
              child: SizedBox(
                  height: 34,
                  child: BlocBuilder<AccountListPageBloc, AccountListPageState>(
                    buildWhen: (previous, current) =>
                        previous != current &&
                            current is AccountListPageFilteredState ||
                        current is AccountListPageSelectedGroupState ||
                        current is AccountListPageStateLoaded,
                    builder: (context, state) {
                      if (state is AccountListPageStateLoading ||
                          state is AccountListPageStateInitial) {
                        return const AccountGroupListShimmerMolecule();
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, groupIndex) {
                          final group = state.accountGroups[groupIndex];
                          return AccountGroupMolecule(
                              text: group.name,
                              icon: SvgPicture.asset(
                                group.iconName,
                                colorFilter: ColorFilter.mode(
                                    kyTheme.colorOnBackground, BlendMode.srcIn),
                              ),
                              onTap: () => bloc.selectGroup(groupIndex),
                              selected: state.selectedGroupIndex == groupIndex);
                        },
                        itemCount: state.accountGroups.length,
                      );
                    },
                  )),
            ),
          )),
      body: BlocConsumer<AccountListPageBloc, AccountListPageState>(
        listener: (context, state) {},
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType &&
            (previous is AccountListPageStateLoading ||
                current is AccountListPageStateLoaded ||
                current is AccountListPageFilteredState),
        builder: (context, state) {
          if (state is AccountListPageStateLoading ||
              state is AccountListPageStateInitial) {
            return const AccountListShimmerMolecule();
          } else {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child:
                        BlocListener<AccountListPageBloc, AccountListPageState>(
                      listenWhen: (previous, current) =>
                          previous != current &&
                          current is AccountListPageSelectedGroupState,
                      listener: (context, state) {
                        if (state is AccountListPageSelectedGroupState) {
                          pageController.animateToPage(state.selectedGroupIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                      child: PageView.builder(
                        itemCount: state.accountGroups.length,
                        controller: pageController,
                        onPageChanged: (value) {
                          bloc.selectGroup(value);
                        },
                        itemBuilder: (context, groupIndex) => Center(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, accountIndex) {
                              Account account = state.accountGroups[groupIndex]
                                  .accounts[accountIndex];
                              return AccountItemMolecule(
                                  name: account.name,
                                  username: account.fieldUsername.data,
                                  password: account.fieldPassword.data,
                                  imageAsset: account.image!.path);
                            },
                            itemCount: state.accountGroups.isEmpty
                                ? 0
                                : state
                                    .accountGroups[groupIndex].accounts.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const ListItemSeparatorAtom(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      drawer: NavigationDrawer(children: []),
    );
  }
}
