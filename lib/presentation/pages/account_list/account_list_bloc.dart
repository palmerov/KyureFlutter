import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/kiure_service.dart';
import 'package:equatable/equatable.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/vault_service.dart';

class AccountListPageBloc extends Cubit<AccountListPageState> {
  late final KiureService kiureService;
  late final VaultService vaultService;
  bool listenPageView = true;

  AccountListPageBloc() : super(const AccountListPageStateInitial()) {
    kiureService = serviceLocator.getKiureService();
    vaultService = serviceLocator.getVaultService();
  }

  void load() async {
    emit(AccountListPageStateLoaded(
        accounts: vaultService.accounts!, groups: vaultService.groups!));
  }

  void filter(String filter) {
    if (filter.trim().isNotEmpty) {
      List<Account> accounts = vaultService.accounts!
          .where((account) =>
              (account.name.toLowerCase().contains(filter.toLowerCase()) ||
                  account.fieldUsername.data
                      .toLowerCase()
                      .contains(filter.toLowerCase()) ||
                  account.fieldPassword.data
                      .toLowerCase()
                      .contains(filter.toLowerCase())))
          .toList();
      if (accounts.length != state.accounts.length) {
        emit(AccountListPageFilteredState(
            accounts, state.groups, state.selectedGroupIndex, filter));
      }
    } else {
      emit(AccountListPageStateLoaded(
          accounts: vaultService.accounts!,
          groups: state.groups,
          selectedGroupIndex: state.selectedGroupIndex));
    }
  }

  void selectGroup(int index) {
    if (state.selectedGroupIndex == index) return;
    emit(AccountListPageSelectedGroupState(
        vaultService.accounts!, vaultService.groups!, index));
  }

  void reload(bool updateDate) {
    vaultService.saveVaultData(false, updateDate);
    emit(state.copyWith(version: state.version + 1));
  }

  void deleteAccount(Account account) {
    vaultService.deleteAccount(account);
    emit(state.copyWith(version: state.version + 1));
  }

  void deleteGroup(AccountGroup group) {
    vaultService.deleteGroup(group);
    emit(state.copyWith(version: state.version + 1));
  }

  Future<String> exportFile() async {
    return await kiureService.exportFile();
  }

  void sort(SortBy method) {
    vaultService.sort(method);
    emit(state.copyWith(version: state.version + 1));
  }
}

class AccountListPageState extends Equatable {
  const AccountListPageState(
      {this.accounts = const [],
      this.groups = const [],
      this.selectedGroupIndex = 0,
      this.filter = '',
      this.version = 0});
  final List<Account> accounts;
  final List<AccountGroup> groups;
  final int selectedGroupIndex;
  final int version;
  final String filter;

  AccountListPageState copyWith(
      {List<Account>? accounts,
      List<AccountGroup>? groups,
      int? selectedGroupIndex,
      String? filter,
      int? version}) {
    return AccountListPageState(
        accounts: accounts ?? this.accounts,
        groups: groups ?? this.groups,
        version: version ?? this.version,
        filter: filter ?? this.filter,
        selectedGroupIndex: selectedGroupIndex ?? this.selectedGroupIndex);
  }

  @override
  List<Object?> get props =>
      [selectedGroupIndex, accounts.length, filter, version];
}

class AccountListPageStateInitial extends AccountListPageState {
  const AccountListPageStateInitial();
}

class AccountListPageStateLoading extends AccountListPageState {
  const AccountListPageStateLoading();
}

class AccountListPageStateLoaded extends AccountListPageState {
  const AccountListPageStateLoaded(
      {required List<Account> accounts,
      required List<AccountGroup> groups,
      int selectedGroupIndex = 0})
      : super(
            accounts: accounts,
            groups: groups,
            selectedGroupIndex: selectedGroupIndex,
            version: 1);
}

class AccountListPageFilteredState extends AccountListPageState {
  const AccountListPageFilteredState(List<Account> accounts,
      List<AccountGroup> groups, int selectedGroupIndex, String filter)
      : super(
            accounts: accounts,
            groups: groups,
            selectedGroupIndex: selectedGroupIndex,
            filter: filter,
            version: 1);
}

class AccountListPageStateError extends AccountListPageState {
  const AccountListPageStateError(String error);
}

class AccountListPageSelectedGroupState extends AccountListPageState {
  const AccountListPageSelectedGroupState(
      List<Account> accounts, List<AccountGroup> groups, int selectedGroupIndex)
      : super(
            accounts: accounts,
            groups: groups,
            selectedGroupIndex: selectedGroupIndex);
}
