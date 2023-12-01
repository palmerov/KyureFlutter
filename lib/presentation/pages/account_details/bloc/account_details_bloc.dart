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
        super(AccountDetailsInitial(
            selectedGroup: group,
            editting: editting,
            assetImage: account.image.path)) {
    if (editting) {
      accountCopy = account;
    }
  }

  void selectImage(String image) {
    accountCopy!.image = AccountImage(path: image, source: ImageSource.assets);
    emit(state.copyWith(assetImage: image));
  }

  void selectGroup(AccountGroup group) {
    if (group.name != groupTo?.name) {
      groupTo = group;
      emit(state.copyWith(selectedGroup: group));
    }
  }

  void edit() {
    accountCopy = Account(
        id: account.id,
        name: account.name,
        image: account.image,
        fieldPassword: AccountField(
            name: account.fieldPassword.name,
            data: account.fieldPassword.data,
            visible: account.fieldPassword.visible),
        fieldUsername: AccountField(
            name: account.fieldUsername.name,
            data: account.fieldUsername.data,
            visible: account.fieldUsername.visible),
        fieldList: account.fieldList
            ?.map((e) =>
                AccountField(name: e.name, data: e.data, visible: e.visible))
            .toList());
    emit(state.copyWith(editting: true));
  }

  void save(String name, List<AccountField> fields) {
    accountCopy!.name = name;
    accountCopy!.fieldUsername = fields[0];
    accountCopy!.fieldPassword = fields[1];
    accountCopy!.fieldList = fields.isEmpty ? null : fields.sublist(2);
    if (isNewAccount) {
      groupTo ??= group;
      groupTo!.accounts.add(accountCopy!);
      isNewAccount = false;
    } else {
      if (groupTo != null) {
        group.accounts.removeWhere((element) => element.id == account.id);
        groupTo!.accounts.add(accountCopy!);
        account = accountCopy ?? account;
      } else {
        account.name = accountCopy!.name;
        account.image = accountCopy!.image;
        account.fieldPassword = accountCopy!.fieldPassword;
        account.fieldUsername = accountCopy!.fieldUsername;
        account.fieldList = accountCopy!.fieldList;
      }
    }
    group = groupTo ?? group;
    emit(state.copyWith(editting: false));
  }
}

class AccountDetailsState extends Equatable {
  const AccountDetailsState({
    required this.selectedGroup,
    required this.editting,
    required this.assetImage,
  });
  final AccountGroup selectedGroup;
  final bool editting;
  final String assetImage;
  @override
  List<Object?> get props => [selectedGroup.name, editting, assetImage];

  //copy with
  AccountDetailsState copyWith(
      {AccountGroup? selectedGroup, bool? editting, String? assetImage}) {
    return AccountDetailsState(
        assetImage: assetImage ?? this.assetImage,
        selectedGroup: selectedGroup ?? this.selectedGroup,
        editting: editting ?? this.editting);
  }
}

class AccountDetailsInitial extends AccountDetailsState {
  const AccountDetailsInitial({
    required super.selectedGroup,
    required super.editting,
    required super.assetImage,
  });
}
