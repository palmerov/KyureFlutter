import 'package:flutter/material.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/widgets/molecules/account_field.dart';

class AccountDetailsPage extends StatelessWidget {
  const AccountDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AccountDetailsView();
  }
}

class _AccountDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: AccountFieldMolecule(
              editing: true,
              accountField: AccountField(
                  name: 'Username',
                  data: 'palmerovaldes99@gmail.com',
                  visible: false)),
        ),
      ),
    );
  }
}
