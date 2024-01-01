import 'package:flutter/material.dart';
import 'package:kyure/config/values.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/service_locator.dart';

class AccountGroupUtils {
  static AccountGroup generateEmptyAccountGroup() {
    return AccountGroup(
      name: '',
      color: Colors.grey.value,
      iconName: '',
      id: -1,
      modifDate: DateTime.now(),
      status: LifeStatus.active,
    );
  }

  static List<AccountGroup> getAllGroups() {
    List<AccountGroup> groupList = [
      GROUP_ALL,
      ...serviceLocator.getVaultService().groups!
    ];
    return groupList;
  }

  static bool assignId(AccountGroup group, Map<int, AccountGroup> groups) {
    int id = group.name.trim().toLowerCase().hashCode;
    if (groups.containsKey(id)) return false;
    group.id = id;
    return true;
  }
}
