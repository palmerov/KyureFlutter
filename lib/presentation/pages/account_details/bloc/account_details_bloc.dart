import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/services/service_locator.dart';

class AccountDetailsBloc extends Cubit<AccountDetailsState> {
  AccountDetailsBloc()
      : super(AccountDetailsInitial(
            selectedGroup: serviceLocator
                .getUserDataService()
                .accountsData!
                .accountGroups
                .first));

  void selectGroup(AccountGroup group) {
    emit(state.copyWith(selectedGroup: group));
  }
}

class AccountDetailsState extends Equatable {
  const AccountDetailsState({required this.selectedGroup});
  final AccountGroup selectedGroup;

  @override
  List<Object?> get props => [selectedGroup.name];

  //copy with
  AccountDetailsState copyWith({AccountGroup? selectedGroup}) {
    return AccountDetailsState(
        selectedGroup: selectedGroup ?? this.selectedGroup);
  }
}

class AccountDetailsInitial extends AccountDetailsState {
  const AccountDetailsInitial({required super.selectedGroup});
}
