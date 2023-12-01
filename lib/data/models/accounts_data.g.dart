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

_$AccountGroupImpl _$$AccountGroupImplFromJson(Map<String, dynamic> json) =>
    _$AccountGroupImpl(
      iconName: json['icon'] as String,
      name: json['name'] as String,
      color: json['color'] as int,
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountGroupImplToJson(_$AccountGroupImpl instance) =>
    <String, dynamic>{
      'icon': instance.iconName,
      'name': instance.name,
      'color': instance.color,
      'accounts': instance.accounts,
    };

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      image: AccountImage.fromJson(json['image'] as Map<String, dynamic>),
      fieldUsername:
          AccountField.fromJson(json['username'] as Map<String, dynamic>),
      fieldPassword:
          AccountField.fromJson(json['password'] as Map<String, dynamic>),
      fieldList: (json['fields'] as List<dynamic>?)
          ?.map((e) => AccountField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'username': instance.fieldUsername,
      'password': instance.fieldPassword,
      'fields': instance.fieldList,
    };

_$AccountFieldImpl _$$AccountFieldImplFromJson(Map<String, dynamic> json) =>
    _$AccountFieldImpl(
      name: json['name'] as String,
      data: json['data'] as String,
      visible: json['visible'] as bool? ?? true,
    );

Map<String, dynamic> _$$AccountFieldImplToJson(_$AccountFieldImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.data,
      'visible': instance.visible,
    };

_$AccountImageImpl _$$AccountImageImplFromJson(Map<String, dynamic> json) =>
    _$AccountImageImpl(
      path: json['path'] as String,
      source: ImageSource.fromJson(json['source'] as String),
    );

Map<String, dynamic> _$$AccountImageImplToJson(_$AccountImageImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'source': instance.source,
    };
