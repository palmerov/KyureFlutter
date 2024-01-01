import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/config/values.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/service_locator.dart';

class AccountDetailsBloc extends Cubit<AccountDetailsState> {
  Account account;
  Account? accountCopy;
  bool isNewAccount;

  AccountDetailsBloc({required this.account, required bool editting})
      : isNewAccount = account.id < 0,
        super(AccountDetailsInitial(
            editting: editting,
            imagePath: account.image.path,
            imageSourceType: account.image.source,
            selectedGroup: serviceLocator
                    .getVaultService()
                    .findGroupById(account.groupId) ??
                GROUP_NILL)) {
    if (editting) {
      edit();
    }
  }

  void selectImage(String image, ImageSourceType source) {
    accountCopy!.image = ImageSource(path: image, source: source);
    emit(state.copyWith(imagePath: image, imageSourceType: source));
  }

  void selectGroup(AccountGroup? group) {
    if (group == null) {
      accountCopy!.groupId = -1;
      emit(state.copyWith(selectedGroup: group));
    } else if (group.id != accountCopy!.groupId) {
      accountCopy!.groupId = group.id;
      emit(state.copyWith(selectedGroup: group));
    }
  }

  void edit() {
    accountCopy = Account(
        groupId: account.groupId,
        modifDate: account.modifDate,
        status: account.status,
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
      serviceLocator.getVaultService().addNewAccount(accountCopy!);
      isNewAccount = false;
      account = accountCopy!;
    } else {
      account.groupId = accountCopy!.groupId;
      account.name = accountCopy!.name;
      account.image = accountCopy!.image;
      account.fieldPassword = accountCopy!.fieldPassword;
      account.fieldUsername = accountCopy!.fieldUsername;
      account.fieldList = accountCopy!.fieldList;
    }
    emit(state.copyWith(editting: false));
  }
}

class AccountDetailsState extends Equatable {
  const AccountDetailsState({
    required this.selectedGroup,
    required this.editting,
    required this.imagePath,
    required this.imageSourceType,
  });
  final AccountGroup selectedGroup;
  final bool editting;
  final String imagePath;
  final ImageSourceType imageSourceType;
  @override
  List<Object?> get props =>
      [selectedGroup.name, editting, imagePath, imageSourceType];

  //copy with
  AccountDetailsState copyWith(
      {AccountGroup? selectedGroup,
      bool? editting,
      String? imagePath,
      ImageSourceType? imageSourceType}) {
    return AccountDetailsState(
        imageSourceType: imageSourceType ?? this.imageSourceType,
        imagePath: imagePath ?? this.imagePath,
        selectedGroup: selectedGroup ?? this.selectedGroup,
        editting: editting ?? this.editting);
  }
}

class AccountDetailsInitial extends AccountDetailsState {
  const AccountDetailsInitial({
    required super.editting,
    required super.imagePath,
    required super.imageSourceType,
    required super.selectedGroup,
  });
}
