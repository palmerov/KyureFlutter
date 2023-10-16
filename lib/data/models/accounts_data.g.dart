// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountsDataImpl _$$AccountsDataImplFromJson(Map<String, dynamic> json) =>
    _$AccountsDataImpl(
      accountGroups: (json['accounts_data'] as List<dynamic>)
          .map((e) => AccountGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountsDataImplToJson(_$AccountsDataImpl instance) =>
    <String, dynamic>{
      'accounts_data': instance.accountGroups,
    };
