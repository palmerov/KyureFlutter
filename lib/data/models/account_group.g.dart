// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountGroupImpl _$$AccountGroupImplFromJson(Map<String, dynamic> json) =>
    _$AccountGroupImpl(
      iconName: json['icon'] as String,
      name: json['name'] as String,
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountGroupImplToJson(_$AccountGroupImpl instance) =>
    <String, dynamic>{
      'icon': instance.iconName,
      'name': instance.name,
      'accounts': instance.accounts,
    };
