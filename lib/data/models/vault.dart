import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kyure/data/models/vault_data.dart';

part 'vault.freezed.dart';
part 'vault.g.dart';

@unfreezed
class Vault with _$Vault {
  factory Vault({
    @JsonKey(name: 'version') required int version,
    @JsonKey(name: 'vault_name') required String vaultName,
    @JsonKey(name: 'datacrypt') required String datacrypt,
    @JsonKey(includeToJson: false, includeFromJson: false) VaultData? accountsData, 
  }) = _Vault;

  factory Vault.fromJson(Map<String, dynamic> json) =>
      _$VaultFromJson(json);
}
