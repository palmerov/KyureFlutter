import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/services/user_data_service.dart';
import 'package:equatable/equatable.dart';

class AccountListPageBloc extends Cubit<AccountListPageState> {
  final UserDataService userDataService;
  bool listenPageView=true;

  AccountListPageBloc(this.userDataService)
      : super(const AccountListPageStateInitial());

  void load() async {
    emit(const AccountListPageStateLoading());
    try {
      await userDataService.readUserData();
    } catch (exception) {
      emit(AccountListPageStateError(exception.toString()));
      return;
    }
    emit(AccountListPageStateLoaded(
        userDataService.accountsData!.accountGroups));
  }

  void filter(String filter) {
    if (filter.trim().isNotEmpty) {
      List<AccountGroup> groups = [];
      for (var group in userDataService.accountsData!.accountGroups) {
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
          userDataService.accountsData!.accountGroups));
    }
  }

  void selectGroup(int index) {
    if (state.selectedGroupIndex == index) return;
    emit(AccountListPageSelectedGroupState(
        userDataService.accountsData!.accountGroups, index));
  }

}

class AccountListPageState extends Equatable {
  const AccountListPageState(
      {required this.accountGroups, this.selectedGroupIndex = 0});
  final List<AccountGroup> accountGroups;
  final int selectedGroupIndex;

  AccountListPageState copyWith(
      {List<AccountGroup>? accountGroups,
      int? selectedGroupIndex,
      String? filter}) {
    return AccountListPageState(
        accountGroups: accountGroups ?? this.accountGroups,
        selectedGroupIndex: selectedGroupIndex ?? this.selectedGroupIndex);
  }

  @override
  List<Object?> get props => [selectedGroupIndex, accountGroups?.length];
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
