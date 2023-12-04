// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VaultImpl _$$VaultImplFromJson(Map<String, dynamic> json) => _$VaultImpl(
      version: json['version'] as int,
      vaultName: json['vault_name'] as String,
      datacrypt: json['datacrypt'] as String,
    );

Map<String, dynamic> _$$VaultImplToJson(_$VaultImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'vault_name': instance.vaultName,
      'datacrypt': instance.datacrypt,
    };
