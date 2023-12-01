import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/models/accounts_data.dart';

class AccountDetailsBloc extends Cubit<AccountDetailsState> {
  AccountGroup group;
  AccountGroup? groupTo;
  Account account;
  Account? accountCopy;
  bool isNewAccount;

  AccountDetailsBloc(
      {required this.account, required this.group, required bool editting})
      : isNewAccount = editting,
        super(AccountDetailsInitial(selectedGroup: group, editting: editting)) {
    if (editting) {
      accountCopy = account.copyWith();
    }
  }

  void selectGroup(AccountGroup group) {
    if (group.name != groupTo?.name) {
      groupTo = group;
      emit(state.copyWith(selectedGroup: group));
    }
  }

  void edit() {
    accountCopy = account.copyWith();
    emit(state.copyWith(editting: true));
  }

  void save() {
    account = accountCopy ?? account;
    if (groupTo != null && !isNewAccount) {
      group.accounts.removeWhere((element) => element.id == account.id);
      groupTo!.accounts.add(account);
    } else {
      if (isNewAccount) {
        group.accounts.add(account);
      } else {
        int index =
            group.accounts.indexWhere((element) => element.id == account.id);
        if (index >= 0) {
          group.accounts[index] = account;
        }
      }
    }
    group = groupTo ?? group;
    isNewAccount = false;
    emit(state.copyWith(editting: false));
  }

  void addField() {
    accountCopy!.fieldList!.add(AccountField(name: '', data: ''));
    emit(state.copyWith());
  }

  void deleteField(int index) {
    accountCopy!.fieldList!.removeAt(index);
    emit(state.copyWith());
  }
}

class AccountDetailsState extends Equatable {
  const AccountDetailsState(
      {required this.selectedGroup, required this.editting});
  final AccountGroup selectedGroup;
  final bool editting;
  @override
  List<Object?> get props => [selectedGroup.name, editting];

  //copy with
  AccountDetailsState copyWith({AccountGroup? selectedGroup, bool? editting}) {
    return AccountDetailsState(
        selectedGroup: selectedGroup ?? this.selectedGroup,
        editting: editting ?? this.editting);
  }
}

class AccountDetailsInitial extends AccountDetailsState {
  const AccountDetailsInitial(
      {required super.selectedGroup, required super.editting});
}
