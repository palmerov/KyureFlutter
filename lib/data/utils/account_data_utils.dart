import 'package:flutter/material.dart';
import 'package:kyure/data/models/accounts_data.dart';

class AccountDataUtils {
  static void createAllGroupIfMoreThan1(AccountsData accountsData) {
    if (accountsData.accountGroups.length > 1) {
      AccountGroup groupAll = AccountGroup(
          iconName: 'assets/svg_icons/widgets.svg',
          color: Colors.blue.shade700.value,
          name: 'Todos',
          accounts: []);
      for (AccountGroup group in accountsData.accountGroups) {
        groupAll.accounts.addAll(group.accounts);
      }
      accountsData.accountGroups.insert(0, groupAll);
    }
  }
}
