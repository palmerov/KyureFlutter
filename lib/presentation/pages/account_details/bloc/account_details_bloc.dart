import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/service_locator.dart';

class AccountDetailsBloc extends Cubit<AccountDetailsState> {
  AccountGroup group;
  AccountGroup? groupTo;
  Account account;
  Account? accountCopy;
  bool isNewAccount;

  AccountDetailsBloc(
      {required this.account, required this.group, required bool editting})
      : isNewAccount = account.id < 0,
        super(AccountDetailsInitial(
            imageSource: account.image.source,
            selectedGroup: group,
            editting: editting,
            imagePath: account.image.path)) {
    if (editting) {
      edit();
    }
  }

  void selectImage(String image, ImageSource source) {
    accountCopy!.image = AccountImage(path: image, source: source);
    emit(state.copyWith(imagePath: image, imageSource: source));
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
      serviceLocator.getKiureService().addNewAccount(accountCopy!, groupTo!);
      isNewAccount = false;
      account = accountCopy!;
    } else {
      if (groupTo != null) {
        serviceLocator.getKiureService().moveInGroups(account, group, groupTo!);
      }
      account.name = accountCopy!.name;
      account.image = accountCopy!.image;
      account.fieldPassword = accountCopy!.fieldPassword;
      account.fieldUsername = accountCopy!.fieldUsername;
      account.fieldList = accountCopy!.fieldList;
    }
    group = groupTo ?? group;
    emit(state.copyWith(editting: false));
  }
}

class AccountDetailsState extends Equatable {
  const AccountDetailsState({
    required this.selectedGroup,
    required this.editting,
    required this.imagePath,
    required this.imageSource,
  });
  final AccountGroup selectedGroup;
  final bool editting;
  final String imagePath;
  final ImageSource imageSource;
  @override
  List<Object?> get props =>
      [selectedGroup.name, editting, imagePath, imageSource];

  //copy with
  AccountDetailsState copyWith(
      {AccountGroup? selectedGroup,
      bool? editting,
      String? imagePath,
      ImageSource? imageSource}) {
    return AccountDetailsState(
        imageSource: imageSource ?? this.imageSource,
        imagePath: imagePath ?? this.imagePath,
        selectedGroup: selectedGroup ?? this.selectedGroup,
        editting: editting ?? this.editting);
  }
}

class AccountDetailsInitial extends AccountDetailsState {
  const AccountDetailsInitial({
    required super.selectedGroup,
    required super.editting,
    required super.imagePath,
    required super.imageSource,
  });
}
