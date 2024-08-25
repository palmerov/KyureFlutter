import 'package:kyure/data/models/vault_data.dart';

class Vault {
  String vaultName;
  DateTime modifDate;
  String datacrypt;
  VaultData? data;

  Vault({
    required this.vaultName,
    required this.modifDate,
    required this.datacrypt,
    this.data,
  });

  factory Vault.fromJson(Map<String, dynamic> json) => Vault(
      vaultName: json['vault_name'],
      modifDate: DateTime.parse(json['modif_date']),
      datacrypt: json['datacrypt']);

  // to json
  Map<String, dynamic> toJson() => {
        'vault_name': vaultName,
        'modif_date': modifDate.toIso8601String(),
        'datacrypt': datacrypt,
      };

}
