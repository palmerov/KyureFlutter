import 'package:flutter/material.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/presentation/widgets/molecules/account_field.dart';
import 'package:kyure/services/service_locator.dart';

class AccountFormDataOrganism extends StatefulWidget {
  const AccountFormDataOrganism({
    super.key,
    required this.account,
    required this.editting,
    required this.onAccountDelete,
    required this.keyList,
  });

  final Account account;
  final bool editting;
  final GlobalKey<AnimatedListState> keyList;
  final Function(int index) onAccountDelete;

  @override
  State<AccountFormDataOrganism> createState() =>
      AccountFormDataOrganismState();
}

class AccountFormDataOrganismState extends State<AccountFormDataOrganism> {
  late final List<AccountFieldWrapper> accountList;
  late final Account account;
  late final bool editting;
  late final GlobalKey<AnimatedListState> keyList;
  late final Function(int index) onAccountDelete;

  @override
  void initState() {
    super.initState();
    account = widget.account;
    editting = widget.editting;
    keyList = widget.keyList;
    onAccountDelete = widget.onAccountDelete;

    accountList = [
      AccountFieldWrapper(1, account.fieldUsername, false),
      AccountFieldWrapper(2, account.fieldPassword, false)
    ];
    int i = 3;
    for (var element in account.fieldList ?? []) {
      accountList.add(AccountFieldWrapper(i++, element, true));
    }
  }

  List<AccountField> getAccountFields() {
    List<AccountField> accountFields = [];
    for (var element in accountList) {
      accountFields.add(element.accountField);
    }
    return accountFields;
  }

  void addField(AccountField accountField) {
    accountList.add(AccountFieldWrapper(accountList.last.id + 1, accountField, true));
    keyList.currentState!.insertItem(accountList.length - 1);
  }

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.only(bottom: 4),
      child: AccountFieldMolecule(
        onCopy: () => serviceLocator.getKiureService().addToRecents(account),
        editting: widget.editting,
        accountField: accountField.accountField,
        onFieldChanged: (String name, String data, bool visible) {
          accountField.accountField.name = name;
          accountField.accountField.data = data;
          accountField.accountField.visible = visible;
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
        editableVisibility: accountField.editableVisibility,
      ),
    );
  }
}

class AccountFieldWrapper {
  AccountFieldWrapper(this.id, this.accountField, this.editableVisibility);
  final AccountField accountField;
  final int id;
  final bool editableVisibility;
}
