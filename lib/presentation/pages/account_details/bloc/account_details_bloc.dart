import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/config/values.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/service_locator.dart';

class AccountDetailsBloc extends Cubit<AccountDetailsState> {
  Account account;
  Account? accountCopy;
  bool isNewAccount;

  AccountDetailsBloc({required this.account, required bool editing})
      : isNewAccount = account.id < 0,
        super(AccountDetailsInitial(
            editing: editing,
            imagePath: account.image.data,
            imageSourceType: account.image.source,
            selectedGroup: serviceLocator
                    .getVaultService()
                    .findGroupById(account.groupId) ??
                GROUP_ALL)) {
    if (editing) {
      edit();
    }
  }

  void selectImage(String image, ImageSourceType source) {
    accountCopy!.image = ImageSource(data: image, source: source);
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
            type: account.fieldPassword.type),
        fieldUsername: AccountField(
            name: account.fieldUsername.name,
            data: account.fieldUsername.data,
            type: account.fieldUsername.type),
        fieldList: account.fieldList
            ?.map((e) =>
                AccountField(name: e.name, data: e.data, type: e.type))
            .toList());
    emit(state.copyWith(editing: true));
  }

  save(String name, List<AccountField> fields) async {
    accountCopy!.name = name;
    accountCopy!.fieldUsername = fields[0];
    accountCopy!.fieldPassword = fields[1];
    accountCopy!.fieldList = fields.isEmpty ? null : fields.sublist(2);
    if (isNewAccount) {
      if (await serviceLocator.getVaultService().addNewAccount(accountCopy!)) {
        isNewAccount = false;
        account = accountCopy!;
        account.modifDate = DateTime.now();
      } else {
        emit(ErrorSavingState(
            dateTime: DateTime.now(),
            error:
                'Ya tienes una cuenta llamada "${accountCopy!.name}" y con nombre de usuario "${accountCopy!.fieldUsername.data}". Debes cambiar alguno de los dos campos.',
            editing: true,
            imagePath: state.imagePath,
            imageSourceType: state.imageSourceType,
            selectedGroup: state.selectedGroup));
        return;
      }
    } else {
      account.modifDate = DateTime.now();
      account.groupId = accountCopy!.groupId;
      account.name = accountCopy!.name;
      account.image = accountCopy!.image;
      account.fieldPassword = accountCopy!.fieldPassword;
      account.fieldUsername = accountCopy!.fieldUsername;
      account.fieldList = accountCopy!.fieldList;
    }
    emit(state.copyWith(editing: false));
  }
}

class AccountDetailsState extends Equatable {
  const AccountDetailsState({
    required this.selectedGroup,
    required this.editing,
    required this.imagePath,
    required this.imageSourceType,
  });

  final AccountGroup selectedGroup;
  final bool editing;
  final String imagePath;
  final ImageSourceType imageSourceType;

  @override
  List<Object?> get props =>
      [selectedGroup.name, editing, imagePath, imageSourceType];

  //copy with
  AccountDetailsState copyWith(
      {AccountGroup? selectedGroup,
      bool? editing,
      String? imagePath,
      ImageSourceType? imageSourceType}) {
    return AccountDetailsState(
        imageSourceType: imageSourceType ?? this.imageSourceType,
        imagePath: imagePath ?? this.imagePath,
        selectedGroup: selectedGroup ?? this.selectedGroup,
        editing: editing ?? this.editing);
  }
}

class AccountDetailsInitial extends AccountDetailsState {
  const AccountDetailsInitial({
    required super.editing,
    required super.imagePath,
    required super.imageSourceType,
    required super.selectedGroup,
  });
}

class ErrorSavingState extends AccountDetailsState {
  const ErrorSavingState({
    required this.dateTime,
    required this.error,
    required super.editing,
    required super.imagePath,
    required super.imageSourceType,
    required super.selectedGroup,
  });

  final String error;
  final DateTime dateTime;

  @override
  List<Object?> get props => [error, dateTime, ...super.props];
}
