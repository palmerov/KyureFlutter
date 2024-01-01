import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/kiure_service.dart';
import 'package:equatable/equatable.dart';

class AccountListPageBloc extends Cubit<AccountListPageState> {
  final KiureService userDataService;
  bool listenPageView = true;

  AccountListPageBloc(this.userDataService)
      : super(const AccountListPageStateInitial());

  void load() async {
    emit(AccountListPageStateLoaded(
        userDataService.vault!.accountGroups));
  }

  void filter(String filter) {
    if (filter.trim().isNotEmpty) {
      List<AccountGroup> groups = [];
      for (var group in userDataService.vault!.accountGroups) {
        List<Account> accounts = [];
        for (var account in group.accounts) {
          if (account.name.toLowerCase().contains(filter.toLowerCase()) ||
              account.fieldUsername.data
                  .toLowerCase()
                  .contains(filter.toLowerCase()) ||
              account.fieldPassword.data
                  .toLowerCase()
                  .contains(filter.toLowerCase())) {
            accounts.add(account);
          }
        }
        if (accounts.isNotEmpty) {
          groups.add(AccountGroup(
              iconName: group.iconName,
              color: group.color,
              name: group.name,
              accounts: accounts));
        }
      }
      bool equal = true;
      if (groups.length != state.accountGroups.length) {
        for (int i = 0; i < groups.length; i++) {
          if (groups[i].accounts.length !=
              state.accountGroups[i].accounts.length) {
            equal = false;
            break;
          }
        }
      }
      if (!equal) emit(AccountListPageFilteredState(groups, filter));
    } else {
      emit(AccountListPageStateLoaded(
          userDataService.vault!.accountGroups));
    }
  }

  void selectGroup(int index) {
    if (state.selectedGroupIndex == index) return;
    emit(AccountListPageSelectedGroupState(
        userDataService.vault!.accountGroups, index));
  }

  void reload() {
    userDataService.saveVaultData();
    emit(state.copyWith(version: state.version + 1));
  }

  void deleteAccount(Account account) {
    userDataService.deleteAccount(account);
    reload();
  }

  void deleteGroup(AccountGroup group) {
    userDataService.deleteGroup(group);
    reload();
  }

  Future<String> exportFile() async {
    return await userDataService.exportFile();
  }

  void sort(SortMethod method) {
    userDataService.sort(state.selectedGroupIndex, method);
    reload();
  }
}

class AccountListPageState extends Equatable {
  const AccountListPageState(
      {required this.accountGroups,
      this.selectedGroupIndex = 0,
      this.version = 0});
  final List<AccountGroup> accountGroups;
  final int selectedGroupIndex;
  final int version;

  AccountListPageState copyWith(
      {List<AccountGroup>? accountGroups,
      int? selectedGroupIndex,
      int? version,
      String? filter}) {
    return AccountListPageState(
        accountGroups: accountGroups ?? this.accountGroups,
        version: version ?? this.version,
        selectedGroupIndex: selectedGroupIndex ?? this.selectedGroupIndex);
  }

  @override
  List<Object?> get props =>
      [selectedGroupIndex, accountGroups.length, version];
}

class AccountListPageStateInitial extends AccountListPageState {
  const AccountListPageStateInitial() : super(accountGroups: const []);
}

class AccountListPageStateLoading extends AccountListPageState {
  const AccountListPageStateLoading() : super(accountGroups: const []);
}

class AccountListPageStateLoaded extends AccountListPageState {
  const AccountListPageStateLoaded(List<AccountGroup> accountGroups)
      : super(accountGroups: accountGroups);
}

class AccountListPageStateError extends AccountListPageState {
  const AccountListPageStateError(String error)
      : super(accountGroups: const []);
}

class AccountListPageFilteredState extends AccountListPageState {
  const AccountListPageFilteredState(
      List<AccountGroup> accountGroups, this.filter)
      : super(accountGroups: accountGroups);
  final String filter;

  @override
  List<Object?> get props => [selectedGroupIndex, accountGroups.length, filter];
}

class AccountListPageSelectedGroupState extends AccountListPageState {
  const AccountListPageSelectedGroupState(
      List<AccountGroup> accountGroups, int selectedGroupIndex)
      : super(
            accountGroups: accountGroups,
            selectedGroupIndex: selectedGroupIndex);
}
