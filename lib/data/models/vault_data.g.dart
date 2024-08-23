// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VaultDataImpl _$$VaultDataImplFromJson(Map<String, dynamic> json) =>
    _$VaultDataImpl(
      accounts: (json['accounts'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(int.parse(k), Account.fromJson(e as Map<String, dynamic>)),
      ),
      deletedAccounts: (json['del_accounts'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(int.parse(k), Account.fromJson(e as Map<String, dynamic>)),
      ),
      groups: (json['groups'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), AccountGroup.fromJson(e as Map<String, dynamic>)),
      ),
      deletedGroups: (json['del_groups'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), AccountGroup.fromJson(e as Map<String, dynamic>)),
      ),
      sort: SortBy.fromJson(json['sort'] as int),
      modifDate: DateTime.parse(json['modif_date'] as String),
    );

Map<String, dynamic> _$$VaultDataImplToJson(_$VaultDataImpl instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.map((k, e) => MapEntry(k.toString(), e)),
      'del_accounts':
          instance.deletedAccounts.map((k, e) => MapEntry(k.toString(), e)),
      'groups': instance.groups.map((k, e) => MapEntry(k.toString(), e)),
      'del_groups':
          instance.deletedGroups.map((k, e) => MapEntry(k.toString(), e)),
      'sort': instance.sort,
      'modif_date': instance.modifDate.toIso8601String(),
    };

_$AccountGroupImpl _$$AccountGroupImplFromJson(Map<String, dynamic> json) =>
    _$AccountGroupImpl(
      id: json['id'] as int,
      iconName: json['icon'] as String,
      name: json['name'] as String,
      color: json['color'] as int,
      modifDate: DateTime.parse(json['modif_date'] as String),
      status: LifeStatus.fromJson(json['status'] as int),
    );

Map<String, dynamic> _$$AccountGroupImplToJson(_$AccountGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'icon': instance.iconName,
      'name': instance.name,
      'color': instance.color,
      'modif_date': instance.modifDate.toIso8601String(),
      'status': instance.status,
    };

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: json['id'] as int,
      groupId: json['group_id'] as int,
      status: LifeStatus.fromJson(json['status'] as int),
      name: json['name'] as String,
      modifDate: DateTime.parse(json['modif_date'] as String),
      image: ImageSource.fromJson(json['image'] as Map<String, dynamic>),
      fieldUrl: json['url'] == null
          ? null
          : AccountField.fromJson(json['url'] as Map<String, dynamic>),
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
      'group_id': instance.groupId,
      'status': instance.status,
      'name': instance.name,
      'modif_date': instance.modifDate.toIso8601String(),
      'image': instance.image,
      'url': instance.fieldUrl,
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

_$ImageSourceImpl _$$ImageSourceImplFromJson(Map<String, dynamic> json) =>
    _$ImageSourceImpl(
      path: json['path'] as String,
      source: ImageSourceType.fromJson(json['source'] as String),
    );

Map<String, dynamic> _$$ImageSourceImplToJson(_$ImageSourceImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'source': instance.source,
    };
