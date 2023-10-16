// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      fieldUsername:
          AccountField.fromJson(json['username'] as Map<String, dynamic>),
      fieldPassword:
          AccountField.fromJson(json['password'] as Map<String, dynamic>),
      fieldList: (json['fields'] as List<dynamic>)
          .map((e) => AccountField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.fieldUsername,
      'password': instance.fieldPassword,
      'fields': instance.fieldList,
    };
