// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VaultImpl _$$VaultImplFromJson(Map<String, dynamic> json) => _$VaultImpl(
      vaultName: json['vault_name'] as String,
      modifDate: DateTime.parse(json['modif_date'] as String),
      datacrypt: json['datacrypt'] as String,
    );

Map<String, dynamic> _$$VaultImplToJson(_$VaultImpl instance) =>
    <String, dynamic>{
      'vault_name': instance.vaultName,
      'modif_date': instance.modifDate.toIso8601String(),
      'datacrypt': instance.datacrypt,
    };
