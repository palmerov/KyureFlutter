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
      GROUP_NILL,
      ...serviceLocator.getVaultService().groups!
    ];
    return groupList;
  }
}
