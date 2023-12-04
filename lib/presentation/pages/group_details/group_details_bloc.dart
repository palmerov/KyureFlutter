import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/service_locator.dart';

class GroupDetailsBloc extends Cubit<GroupDetailsState> {
  AccountGroup group;
  AccountGroup groupCopy;
  bool saved = false;
  final bool isNew;

  GroupDetailsBloc({required this.group, this.isNew = false})
      : groupCopy = AccountGroup(
            iconName: group.iconName,
            name: group.name,
            color: group.color,
            accounts: group.accounts),
        super(GroupDetailsInitial(
            color: Color(group.color),
            iconName: group.iconName,
            name: group.name));

  void save() {
    group.name = groupCopy.name;
    group.iconName = groupCopy.iconName;
    group.color = groupCopy.color;
    saved = true;
    if (isNew) {
      serviceLocator
          .getKiureService()
          .vault
          .accountGroups
          .add(group);
    }
  }

  void setColor(Color color) {
    groupCopy.color = color.value;
    emit(state.copyWith(color: color));
  }

  void setIconName(String iconName) {
    groupCopy.iconName = iconName;
    emit(state.copyWith(iconName: iconName));
  }

  void setName(String name) {
    groupCopy.name = name;
    emit(state.copyWith(name: name));
  }
}

class GroupDetailsState extends Equatable {
  const GroupDetailsState(
      {required this.color, required this.iconName, required this.name});
  final Color color;
  final String iconName;
  final String name;

  @override
  List<Object?> get props => [color, iconName, name];

  GroupDetailsState copyWith({
    Color? color,
    String? iconName,
    String? name,
  }) {
    return GroupDetailsState(
      color: color ?? this.color,
      iconName: iconName ?? this.iconName,
      name: name ?? this.name,
    );
  }
}

class GroupDetailsInitial extends GroupDetailsState {
  const GroupDetailsInitial(
      {required super.color, required super.iconName, required super.name});
}
