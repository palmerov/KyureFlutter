import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/utils/dialog_utils.dart';
import 'package:kyure/services/kiure_service.dart';
import 'package:equatable/equatable.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/vault_service.dart';
import 'package:quickalert/models/quickalert_type.dart';

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
    emit(state.copyWith(version: state.version + 1, selectedGroupIndex: 0));
  }

  Future<String> exportFile() async {
    return await kiureService.exportFile();
  }

  void sort(SortBy method) {
    vaultService.sort(method);
    emit(state.copyWith(version: state.version + 1));
  }

  syncWithFile([String? key]) async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.any);
    if (result != null) {
      File file = File(result.files.single.path!);
      final syncResult = await vaultService.syncWithFile(null, file);
      switch (syncResult) {
        case SyncResult.success:
          emit(state.copyWith(
              alertMessage: AlertMessage(
                type: QuickAlertType.success,
                text: 'Sincronizado con éxito',
                confirmBtnText: 'Ok',
              ),
              version: state.version + 1,
              accounts: vaultService.accounts!,
              groups: vaultService.groups!));
          break;
        case SyncResult.incompatible:
          // TODO: incompatible error
          break;
        case SyncResult.wrongRemoteKey:
          // TODO: show insert remote key
          break;
        case SyncResult.accessError:
      }
    }
  }

  List<Account> getAccountListByGroupId(int groupId) {
    if (groupId < 0) {
      return state.accounts;
    }
    return state.accounts
        .where((account) => account.groupId == groupId)
        .toList();
  }

  AccountGroup getSelectedGroup() {
    return vaultService.groups![state.selectedGroupIndex];
  }

  List<Account> getAccountsFromSelectedGroup() {
    return getAccountListByGroupId(getSelectedGroup().id);
  }

  List<Account> getAccountsFromGroupIndex(int groupIndex) {
    if (groupIndex == 0) return state.accounts;
    return getAccountListByGroupId(vaultService.groups![groupIndex].id);
  }
}

class AccountListPageState extends Equatable {
  const AccountListPageState(
      {this.accounts = const [],
      this.groups = const [],
      this.selectedGroupIndex = 0,
      this.filter = '',
      this.version = 0,
      this.alertMessage});

  final List<Account> accounts;
  final List<AccountGroup> groups;
  final int selectedGroupIndex;
  final int version;
  final String filter;
  final AlertMessage? alertMessage;

  AccountListPageState copyWith(
      {List<Account>? accounts,
      List<AccountGroup>? groups,
      int? selectedGroupIndex,
      String? filter,
      int? version,
      AlertMessage? alertMessage}) {
    return AccountListPageState(
        accounts: accounts ?? this.accounts,
        groups: groups ?? this.groups,
        version: version ?? this.version,
        filter: filter ?? this.filter,
        alertMessage: alertMessage,
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

  @override
  List<Object?> get props =>
      [selectedGroupIndex, accounts.length, filter, version];
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
