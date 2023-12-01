import 'package:flutter/material.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/account_field.dart';

class AccountFormDataOrganism extends StatefulWidget {
  const AccountFormDataOrganism(
      {super.key,
      required this.account,
      required this.editting,
      required this.onAccountDelete,
      required this.keyList,
      required this.controller});

  final Account account;
  final bool editting;
  final GlobalKey<AnimatedListState> keyList;
  final Function(int index) onAccountDelete;
  final AccountFormController controller;

  @override
  State<AccountFormDataOrganism> createState() =>
      _AccountFormDataOrganismState();
}

class _AccountFormDataOrganismState extends State<AccountFormDataOrganism> {
  late final List<AccountFieldWrapper> accountList;
  late final Account account;
  late final bool editting;
  late final GlobalKey<AnimatedListState> keyList;
  late final Function(int index) onAccountDelete;
  late final AccountFormController controller;

  @override
  void initState() {
    super.initState();
    account = widget.account;
    editting = widget.editting;
    keyList = widget.keyList;
    onAccountDelete = widget.onAccountDelete;
    controller = widget.controller;

    accountList = [
      AccountFieldWrapper(1, account.fieldUsername),
      AccountFieldWrapper(2, account.fieldPassword)
    ];
    int i = 3;
    for (var element in account.fieldList ?? []) {
      accountList.add(AccountFieldWrapper(i++, element));
    }

    controller.addField = (AccountField accountField) {
      accountList
          .add(AccountFieldWrapper(accountList.last.id + 1, accountField));
      keyList.currentState!.insertItem(accountList.length - 1);
    };

    controller.getAccountFields = () {
      List<AccountField> accountFields = [];
      for (var element in accountList) {
        accountFields.add(element.accountField);
      }
      return accountFields;
    };
  }

  @override
  Widget build(BuildContext context) {
    final kTheme = KyTheme.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AnimatedList(
              physics: const BouncingScrollPhysics(),
              key: widget.keyList,
              itemBuilder: (context, index, animation) {
                return switch (index) {
                  0 => _buildField(index, accountList[0]),
                  1 => _buildField(index, accountList[1]),
                  _ => AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) =>
                          SizeTransition(sizeFactor: animation, child: child),
                      child: _buildField(index, accountList[index]),
                    )
                };
              },
              initialItemCount: accountList.length),
        ),
      ],
    );
  }

  Widget _buildField(int index, AccountFieldWrapper accountField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AccountFieldMolecule(
        editting: widget.editting,
        accountField: accountField.accountField,
        onFieldChanged: (String name, String data) {
          accountField.accountField.name = name;
          accountField.accountField.data = data;
        },
        onTapDelete: index > 1
            ? () {
                int currentIndex = accountList
                    .indexWhere((element) => element.id == accountField.id);
                widget.onAccountDelete(currentIndex - 2);
                accountList.removeAt(currentIndex);
                widget.keyList.currentState!.removeItem(
                    index,
                    (context, animation) => AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) =>
                            SizeTransition(sizeFactor: animation, child: child),
                        child: _buildField(index, accountField)),
                    duration: const Duration(milliseconds: 300));
              }
            : null,
      ),
    );
  }
}

class AccountFieldWrapper {
  AccountFieldWrapper(this.id, this.accountField);
  final AccountField accountField;
  final int id;
}

class AccountFormController {
  AccountFormController();
  Function(AccountField accountField)? addField;
  List<AccountField> Function()? getAccountFields;
}
