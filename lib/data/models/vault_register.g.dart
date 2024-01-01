// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RepositoryRegisterImpl _$$RepositoryRegisterImplFromJson(
        Map<String, dynamic> json) =>
    _$RepositoryRegisterImpl(
      registers: (json['registers'] as List<dynamic>)
          .map((e) => VaultRegister.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RepositoryRegisterImplToJson(
        _$RepositoryRegisterImpl instance) =>
    <String, dynamic>{
      'registers': instance.registers,
    };

_$VaultRegisterImpl _$$VaultRegisterImplFromJson(Map<String, dynamic> json) =>
    _$VaultRegisterImpl(
      name: json['name'] as String,
      modifDate: DateTime.parse(json['modif_date'] as String),
      path: json['path'] as String,
    );

Map<String, dynamic> _$$VaultRegisterImplToJson(_$VaultRegisterImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'modif_date': instance.modifDate.toIso8601String(),
      'path': instance.path,
    };
