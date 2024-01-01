import 'package:flutter/material.dart';
import 'package:kyure/data/models/vault_data.dart';

class AccountGroupUtils {
  static AccountGroup generateEmptyAccountGroup() {
    return AccountGroup(
      name: '',
      color: Colors.grey.value,
      iconName: 'assets/svg_icons/widgets.svg',
      id: -1,
      modifDate: DateTime.now(),
      status: LifeStatus.active,
    );
  }

  static bool assignId(AccountGroup group, Map<int, AccountGroup> groups) {
    int id = group.name.trim().toLowerCase().hashCode;
    if (groups.containsKey(id)) return false;
    group.id = id;
    return true;
  }
}
