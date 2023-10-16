import 'package:flutter/material.dart';
import 'package:kyure/data/models/account_group.dart';
import 'package:kyure/data/models/accounts_data.dart';

class AccountGroupUtils {
  static void createAllGroup(AccountsData accountsData) {
    AccountGroup groupAll = AccountGroup(
        iconName: Icons.widgets_rounded.toString(), name: 'All', accounts: []);
    for (AccountGroup group in accountsData.accountGroups) {
      groupAll.accounts.addAll(group.accounts);
    }
    accountsData.accountGroups.add(groupAll);
  }
}
