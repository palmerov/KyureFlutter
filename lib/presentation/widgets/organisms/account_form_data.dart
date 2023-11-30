import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/account_field.dart';

class AccountFormDataOrganism extends StatefulWidget {
  const AccountFormDataOrganism(
      {super.key, required this.account, required this.editting});

  final Account account;
  final bool editting;

  @override
  State<AccountFormDataOrganism> createState() =>
      _AccountFormDataOrganismState();
}

class _AccountFormDataOrganismState extends State<AccountFormDataOrganism> {
  late final Account account;
  late bool editting;

  @override
  void initState() {
    super.initState();
    account = widget.account;
    editting = widget.editting;
  }

  @override
  Widget build(BuildContext context) {
    final kTheme = KyTheme.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(account.fieldUsername),
        _buildField(account.fieldPassword),
        ..._buildFieldList(account.fieldList ?? []),
        FilledButton(
            onPressed: () => setState(() => editting = !editting),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    side:
                        BorderSide(color: kTheme.colorSeparatorLine, width: 1),
                    borderRadius: BorderRadius.circular(12)))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon((editting ? Icons.add : Icons.edit)),
                  const SizedBox(
                    width: 12,
                  ),
                  Text((editting ? 'Agregar campo' : 'Editar')),
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildField(AccountField accountField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AccountFieldMolecule(
        editting: editting,
        accountField: accountField,
      ),
    );
  }

  List<Widget> _buildFieldList(List<AccountField> fields) {
    return fields.map((e) => _buildField(e)).toList();
  }
}
