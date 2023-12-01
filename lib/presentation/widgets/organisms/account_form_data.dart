import 'package:flutter/material.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/atoms/list_item_separator.dart';
import 'package:kyure/presentation/widgets/molecules/account_field.dart';

class AccountFormDataOrganism extends StatelessWidget {
  const AccountFormDataOrganism(
      {super.key,
      required this.account,
      required this.editting,
      required this.onAccountDelete,
      required this.keyList});

  final Account account;
  final bool editting;
  final GlobalKey<AnimatedListState> keyList;
  final Function(int index) onAccountDelete;

  @override
  Widget build(BuildContext context) {
    final kTheme = KyTheme.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AnimatedList(
              key: keyList,
              itemBuilder: (context, index, animation) {
                index = index - 2;
                return switch (index) {
                  -2 => _buildField(index - 2, account.fieldUsername),
                  -1 => _buildField(index - 1, account.fieldPassword),
                  _ => AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) =>
                          SizeTransition(sizeFactor: animation, child: child),
                      child: _buildField(index - 2, account.fieldList![index]),
                    )
                };
              },
              initialItemCount: (account.fieldList?.length ?? 0) + 2),
        ),
      ],
    );
  }

  Widget _buildField(int index, AccountField accountField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AccountFieldMolecule(
        editting: editting,
        accountField: accountField,
        onTapDelete: () {
          if (index >= 0) {
            onAccountDelete(index);
            keyList.currentState!.removeItem(
                index,
                (context, animation) => AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) =>
                        SizeTransition(sizeFactor: animation, child: child),
                    child: _buildField(index, accountField)),
                duration: const Duration(milliseconds: 300));
          }
        },
      ),
    );
  }
}
