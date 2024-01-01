// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VaultData _$VaultDataFromJson(Map<String, dynamic> json) {
  return _VaultData.fromJson(json);
}

/// @nodoc
mixin _$VaultData {
  @JsonKey(name: 'accounts')
  Map<int, Account> get accounts => throw _privateConstructorUsedError;
  @JsonKey(name: 'accounts')
  set accounts(Map<int, Account> value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'del_accounts')
  Map<int, Account> get deletedAccounts => throw _privateConstructorUsedError;
  @JsonKey(name: 'del_accounts')
  set deletedAccounts(Map<int, Account> value) =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'groups')
  Map<int, AccountGroup> get groups => throw _privateConstructorUsedError;
  @JsonKey(name: 'groups')
  set groups(Map<int, AccountGroup> value) =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'del_groups')
  Map<int, AccountGroup> get deletedGroups =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'del_groups')
  set deletedGroups(Map<int, AccountGroup> value) =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'sort')
  SortBy get sort => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort')
  set sort(SortBy value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'modif_date')
  DateTime get modifDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'modif_date')
  set modifDate(DateTime value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VaultDataCopyWith<VaultData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultDataCopyWith<$Res> {
  factory $VaultDataCopyWith(VaultData value, $Res Function(VaultData) then) =
      _$VaultDataCopyWithImpl<$Res, VaultData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'accounts') Map<int, Account> accounts,
      @JsonKey(name: 'del_accounts') Map<int, Account> deletedAccounts,
      @JsonKey(name: 'groups') Map<int, AccountGroup> groups,
      @JsonKey(name: 'del_groups') Map<int, AccountGroup> deletedGroups,
      @JsonKey(name: 'sort') SortBy sort,
      @JsonKey(name: 'modif_date') DateTime modifDate});
}

/// @nodoc
class _$VaultDataCopyWithImpl<$Res, $Val extends VaultData>
    implements $VaultDataCopyWith<$Res> {
  _$VaultDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accounts = null,
    Object? deletedAccounts = null,
    Object? groups = null,
    Object? deletedGroups = null,
    Object? sort = null,
    Object? modifDate = null,
  }) {
    return _then(_value.copyWith(
      accounts: null == accounts
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as Map<int, Account>,
      deletedAccounts: null == deletedAccounts
          ? _value.deletedAccounts
          : deletedAccounts // ignore: cast_nullable_to_non_nullable
              as Map<int, Account>,
      groups: null == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as Map<int, AccountGroup>,
      deletedGroups: null == deletedGroups
          ? _value.deletedGroups
          : deletedGroups // ignore: cast_nullable_to_non_nullable
              as Map<int, AccountGroup>,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortBy,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VaultDataImplCopyWith<$Res>
    implements $VaultDataCopyWith<$Res> {
  factory _$$VaultDataImplCopyWith(
          _$VaultDataImpl value, $Res Function(_$VaultDataImpl) then) =
      __$$VaultDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'accounts') Map<int, Account> accounts,
      @JsonKey(name: 'del_accounts') Map<int, Account> deletedAccounts,
      @JsonKey(name: 'groups') Map<int, AccountGroup> groups,
      @JsonKey(name: 'del_groups') Map<int, AccountGroup> deletedGroups,
      @JsonKey(name: 'sort') SortBy sort,
      @JsonKey(name: 'modif_date') DateTime modifDate});
}

/// @nodoc
class __$$VaultDataImplCopyWithImpl<$Res>
    extends _$VaultDataCopyWithImpl<$Res, _$VaultDataImpl>
    implements _$$VaultDataImplCopyWith<$Res> {
  __$$VaultDataImplCopyWithImpl(
      _$VaultDataImpl _value, $Res Function(_$VaultDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accounts = null,
    Object? deletedAccounts = null,
    Object? groups = null,
    Object? deletedGroups = null,
    Object? sort = null,
    Object? modifDate = null,
  }) {
    return _then(_$VaultDataImpl(
      accounts: null == accounts
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as Map<int, Account>,
      deletedAccounts: null == deletedAccounts
          ? _value.deletedAccounts
          : deletedAccounts // ignore: cast_nullable_to_non_nullable
              as Map<int, Account>,
      groups: null == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as Map<int, AccountGroup>,
      deletedGroups: null == deletedGroups
          ? _value.deletedGroups
          : deletedGroups // ignore: cast_nullable_to_non_nullable
              as Map<int, AccountGroup>,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortBy,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VaultDataImpl implements _VaultData {
  _$VaultDataImpl(
      {@JsonKey(name: 'accounts') required this.accounts,
      @JsonKey(name: 'del_accounts') required this.deletedAccounts,
      @JsonKey(name: 'groups') required this.groups,
      @JsonKey(name: 'del_groups') required this.deletedGroups,
      @JsonKey(name: 'sort') required this.sort,
      @JsonKey(name: 'modif_date') required this.modifDate});

  factory _$VaultDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaultDataImplFromJson(json);

  @override
  @JsonKey(name: 'accounts')
  Map<int, Account> accounts;
  @override
  @JsonKey(name: 'del_accounts')
  Map<int, Account> deletedAccounts;
  @override
  @JsonKey(name: 'groups')
  Map<int, AccountGroup> groups;
  @override
  @JsonKey(name: 'del_groups')
  Map<int, AccountGroup> deletedGroups;
  @override
  @JsonKey(name: 'sort')
  SortBy sort;
  @override
  @JsonKey(name: 'modif_date')
  DateTime modifDate;

  @override
  String toString() {
    return 'VaultData(accounts: $accounts, deletedAccounts: $deletedAccounts, groups: $groups, deletedGroups: $deletedGroups, sort: $sort, modifDate: $modifDate)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultDataImplCopyWith<_$VaultDataImpl> get copyWith =>
      __$$VaultDataImplCopyWithImpl<_$VaultDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VaultDataImplToJson(
      this,
    );
  }
}

abstract class _VaultData implements VaultData {
  factory _VaultData(
      {@JsonKey(name: 'accounts') required Map<int, Account> accounts,
      @JsonKey(name: 'del_accounts') required Map<int, Account> deletedAccounts,
      @JsonKey(name: 'groups') required Map<int, AccountGroup> groups,
      @JsonKey(name: 'del_groups')
      required Map<int, AccountGroup> deletedGroups,
      @JsonKey(name: 'sort') required SortBy sort,
      @JsonKey(name: 'modif_date')
      required DateTime modifDate}) = _$VaultDataImpl;

  factory _VaultData.fromJson(Map<String, dynamic> json) =
      _$VaultDataImpl.fromJson;

  @override
  @JsonKey(name: 'accounts')
  Map<int, Account> get accounts;
  @JsonKey(name: 'accounts')
  set accounts(Map<int, Account> value);
  @override
  @JsonKey(name: 'del_accounts')
  Map<int, Account> get deletedAccounts;
  @JsonKey(name: 'del_accounts')
  set deletedAccounts(Map<int, Account> value);
  @override
  @JsonKey(name: 'groups')
  Map<int, AccountGroup> get groups;
  @JsonKey(name: 'groups')
  set groups(Map<int, AccountGroup> value);
  @override
  @JsonKey(name: 'del_groups')
  Map<int, AccountGroup> get deletedGroups;
  @JsonKey(name: 'del_groups')
  set deletedGroups(Map<int, AccountGroup> value);
  @override
  @JsonKey(name: 'sort')
  SortBy get sort;
  @JsonKey(name: 'sort')
  set sort(SortBy value);
  @override
  @JsonKey(name: 'modif_date')
  DateTime get modifDate;
  @JsonKey(name: 'modif_date')
  set modifDate(DateTime value);
  @override
  @JsonKey(ignore: true)
  _$$VaultDataImplCopyWith<_$VaultDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountGroup _$AccountGroupFromJson(Map<String, dynamic> json) {
  return _AccountGroup.fromJson(json);
}

/// @nodoc
mixin _$AccountGroup {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  set id(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon')
  String get iconName => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon')
  set iconName(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  set name(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'color')
  int get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'color')
  set color(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'modif_date')
  DateTime get modifDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'modif_date')
  set modifDate(DateTime value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  LifeStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  set status(LifeStatus value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountGroupCopyWith<AccountGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountGroupCopyWith<$Res> {
  factory $AccountGroupCopyWith(
          AccountGroup value, $Res Function(AccountGroup) then) =
      _$AccountGroupCopyWithImpl<$Res, AccountGroup>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'icon') String iconName,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'color') int color,
      @JsonKey(name: 'modif_date') DateTime modifDate,
      @JsonKey(name: 'status') LifeStatus status});
}

/// @nodoc
class _$AccountGroupCopyWithImpl<$Res, $Val extends AccountGroup>
    implements $AccountGroupCopyWith<$Res> {
  _$AccountGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? iconName = null,
    Object? name = null,
    Object? color = null,
    Object? modifDate = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LifeStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountGroupImplCopyWith<$Res>
    implements $AccountGroupCopyWith<$Res> {
  factory _$$AccountGroupImplCopyWith(
          _$AccountGroupImpl value, $Res Function(_$AccountGroupImpl) then) =
      __$$AccountGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'icon') String iconName,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'color') int color,
      @JsonKey(name: 'modif_date') DateTime modifDate,
      @JsonKey(name: 'status') LifeStatus status});
}

/// @nodoc
class __$$AccountGroupImplCopyWithImpl<$Res>
    extends _$AccountGroupCopyWithImpl<$Res, _$AccountGroupImpl>
    implements _$$AccountGroupImplCopyWith<$Res> {
  __$$AccountGroupImplCopyWithImpl(
      _$AccountGroupImpl _value, $Res Function(_$AccountGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? iconName = null,
    Object? name = null,
    Object? color = null,
    Object? modifDate = null,
    Object? status = null,
  }) {
    return _then(_$AccountGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LifeStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountGroupImpl implements _AccountGroup {
  _$AccountGroupImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'icon') required this.iconName,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'color') required this.color,
      @JsonKey(name: 'modif_date') required this.modifDate,
      @JsonKey(name: 'status') required this.status});

  factory _$AccountGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountGroupImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  int id;
  @override
  @JsonKey(name: 'icon')
  String iconName;
  @override
  @JsonKey(name: 'name')
  String name;
  @override
  @JsonKey(name: 'color')
  int color;
  @override
  @JsonKey(name: 'modif_date')
  DateTime modifDate;
  @override
  @JsonKey(name: 'status')
  LifeStatus status;

  @override
  String toString() {
    return 'AccountGroup(id: $id, iconName: $iconName, name: $name, color: $color, modifDate: $modifDate, status: $status)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountGroupImplCopyWith<_$AccountGroupImpl> get copyWith =>
      __$$AccountGroupImplCopyWithImpl<_$AccountGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountGroupImplToJson(
      this,
    );
  }
}

abstract class _AccountGroup implements AccountGroup {
  factory _AccountGroup(
          {@JsonKey(name: 'id') required int id,
          @JsonKey(name: 'icon') required String iconName,
          @JsonKey(name: 'name') required String name,
          @JsonKey(name: 'color') required int color,
          @JsonKey(name: 'modif_date') required DateTime modifDate,
          @JsonKey(name: 'status') required LifeStatus status}) =
      _$AccountGroupImpl;

  factory _AccountGroup.fromJson(Map<String, dynamic> json) =
      _$AccountGroupImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @JsonKey(name: 'id')
  set id(int value);
  @override
  @JsonKey(name: 'icon')
  String get iconName;
  @JsonKey(name: 'icon')
  set iconName(String value);
  @override
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'name')
  set name(String value);
  @override
  @JsonKey(name: 'color')
  int get color;
  @JsonKey(name: 'color')
  set color(int value);
  @override
  @JsonKey(name: 'modif_date')
  DateTime get modifDate;
  @JsonKey(name: 'modif_date')
  set modifDate(DateTime value);
  @override
  @JsonKey(name: 'status')
  LifeStatus get status;
  @JsonKey(name: 'status')
  set status(LifeStatus value);
  @override
  @JsonKey(ignore: true)
  _$$AccountGroupImplCopyWith<_$AccountGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  set id(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  int get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  set groupId(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  LifeStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  set status(LifeStatus value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  set name(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'modif_date')
  DateTime get modifDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'modif_date')
  set modifDate(DateTime value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  ImageSource get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  set image(ImageSource value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  AccountField get fieldUsername => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  set fieldUsername(AccountField value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'password')
  AccountField get fieldPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'password')
  set fieldPassword(AccountField value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'fields')
  List<AccountField>? get fieldList => throw _privateConstructorUsedError;
  @JsonKey(name: 'fields')
  set fieldList(List<AccountField>? value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'group_id') int groupId,
      @JsonKey(name: 'status') LifeStatus status,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'modif_date') DateTime modifDate,
      @JsonKey(name: 'image') ImageSource image,
      @JsonKey(name: 'username') AccountField fieldUsername,
      @JsonKey(name: 'password') AccountField fieldPassword,
      @JsonKey(name: 'fields') List<AccountField>? fieldList});

  $ImageSourceCopyWith<$Res> get image;
  $AccountFieldCopyWith<$Res> get fieldUsername;
  $AccountFieldCopyWith<$Res> get fieldPassword;
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? status = null,
    Object? name = null,
    Object? modifDate = null,
    Object? image = null,
    Object? fieldUsername = null,
    Object? fieldPassword = null,
    Object? fieldList = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LifeStatus,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ImageSource,
      fieldUsername: null == fieldUsername
          ? _value.fieldUsername
          : fieldUsername // ignore: cast_nullable_to_non_nullable
              as AccountField,
      fieldPassword: null == fieldPassword
          ? _value.fieldPassword
          : fieldPassword // ignore: cast_nullable_to_non_nullable
              as AccountField,
      fieldList: freezed == fieldList
          ? _value.fieldList
          : fieldList // ignore: cast_nullable_to_non_nullable
              as List<AccountField>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ImageSourceCopyWith<$Res> get image {
    return $ImageSourceCopyWith<$Res>(_value.image, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AccountFieldCopyWith<$Res> get fieldUsername {
    return $AccountFieldCopyWith<$Res>(_value.fieldUsername, (value) {
      return _then(_value.copyWith(fieldUsername: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AccountFieldCopyWith<$Res> get fieldPassword {
    return $AccountFieldCopyWith<$Res>(_value.fieldPassword, (value) {
      return _then(_value.copyWith(fieldPassword: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'group_id') int groupId,
      @JsonKey(name: 'status') LifeStatus status,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'modif_date') DateTime modifDate,
      @JsonKey(name: 'image') ImageSource image,
      @JsonKey(name: 'username') AccountField fieldUsername,
      @JsonKey(name: 'password') AccountField fieldPassword,
      @JsonKey(name: 'fields') List<AccountField>? fieldList});

  @override
  $ImageSourceCopyWith<$Res> get image;
  @override
  $AccountFieldCopyWith<$Res> get fieldUsername;
  @override
  $AccountFieldCopyWith<$Res> get fieldPassword;
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? status = null,
    Object? name = null,
    Object? modifDate = null,
    Object? image = null,
    Object? fieldUsername = null,
    Object? fieldPassword = null,
    Object? fieldList = freezed,
  }) {
    return _then(_$AccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LifeStatus,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ImageSource,
      fieldUsername: null == fieldUsername
          ? _value.fieldUsername
          : fieldUsername // ignore: cast_nullable_to_non_nullable
              as AccountField,
      fieldPassword: null == fieldPassword
          ? _value.fieldPassword
          : fieldPassword // ignore: cast_nullable_to_non_nullable
              as AccountField,
      fieldList: freezed == fieldList
          ? _value.fieldList
          : fieldList // ignore: cast_nullable_to_non_nullable
              as List<AccountField>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountImpl implements _Account {
  _$AccountImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'group_id') required this.groupId,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'modif_date') required this.modifDate,
      @JsonKey(name: 'image') required this.image,
      @JsonKey(name: 'username') required this.fieldUsername,
      @JsonKey(name: 'password') required this.fieldPassword,
      @JsonKey(name: 'fields') this.fieldList});

  factory _$AccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  int id;
  @override
  @JsonKey(name: 'group_id')
  int groupId;
  @override
  @JsonKey(name: 'status')
  LifeStatus status;
  @override
  @JsonKey(name: 'name')
  String name;
  @override
  @JsonKey(name: 'modif_date')
  DateTime modifDate;
  @override
  @JsonKey(name: 'image')
  ImageSource image;
  @override
  @JsonKey(name: 'username')
  AccountField fieldUsername;
  @override
  @JsonKey(name: 'password')
  AccountField fieldPassword;
  @override
  @JsonKey(name: 'fields')
  List<AccountField>? fieldList;

  @override
  String toString() {
    return 'Account(id: $id, groupId: $groupId, status: $status, name: $name, modifDate: $modifDate, image: $image, fieldUsername: $fieldUsername, fieldPassword: $fieldPassword, fieldList: $fieldList)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountImplToJson(
      this,
    );
  }
}

abstract class _Account implements Account {
  factory _Account(
      {@JsonKey(name: 'id') required int id,
      @JsonKey(name: 'group_id') required int groupId,
      @JsonKey(name: 'status') required LifeStatus status,
      @JsonKey(name: 'name') required String name,
      @JsonKey(name: 'modif_date') required DateTime modifDate,
      @JsonKey(name: 'image') required ImageSource image,
      @JsonKey(name: 'username') required AccountField fieldUsername,
      @JsonKey(name: 'password') required AccountField fieldPassword,
      @JsonKey(name: 'fields') List<AccountField>? fieldList}) = _$AccountImpl;

  factory _Account.fromJson(Map<String, dynamic> json) = _$AccountImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @JsonKey(name: 'id')
  set id(int value);
  @override
  @JsonKey(name: 'group_id')
  int get groupId;
  @JsonKey(name: 'group_id')
  set groupId(int value);
  @override
  @JsonKey(name: 'status')
  LifeStatus get status;
  @JsonKey(name: 'status')
  set status(LifeStatus value);
  @override
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'name')
  set name(String value);
  @override
  @JsonKey(name: 'modif_date')
  DateTime get modifDate;
  @JsonKey(name: 'modif_date')
  set modifDate(DateTime value);
  @override
  @JsonKey(name: 'image')
  ImageSource get image;
  @JsonKey(name: 'image')
  set image(ImageSource value);
  @override
  @JsonKey(name: 'username')
  AccountField get fieldUsername;
  @JsonKey(name: 'username')
  set fieldUsername(AccountField value);
  @override
  @JsonKey(name: 'password')
  AccountField get fieldPassword;
  @JsonKey(name: 'password')
  set fieldPassword(AccountField value);
  @override
  @JsonKey(name: 'fields')
  List<AccountField>? get fieldList;
  @JsonKey(name: 'fields')
  set fieldList(List<AccountField>? value);
  @override
  @JsonKey(ignore: true)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountField _$AccountFieldFromJson(Map<String, dynamic> json) {
  return _AccountField.fromJson(json);
}

/// @nodoc
mixin _$AccountField {
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  set name(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'data')
  String get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'data')
  set data(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'visible')
  bool get visible => throw _privateConstructorUsedError;
  @JsonKey(name: 'visible')
  set visible(bool value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountFieldCopyWith<AccountField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountFieldCopyWith<$Res> {
  factory $AccountFieldCopyWith(
          AccountField value, $Res Function(AccountField) then) =
      _$AccountFieldCopyWithImpl<$Res, AccountField>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'data') String data,
      @JsonKey(name: 'visible') bool visible});
}

/// @nodoc
class _$AccountFieldCopyWithImpl<$Res, $Val extends AccountField>
    implements $AccountFieldCopyWith<$Res> {
  _$AccountFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? data = null,
    Object? visible = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountFieldImplCopyWith<$Res>
    implements $AccountFieldCopyWith<$Res> {
  factory _$$AccountFieldImplCopyWith(
          _$AccountFieldImpl value, $Res Function(_$AccountFieldImpl) then) =
      __$$AccountFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'data') String data,
      @JsonKey(name: 'visible') bool visible});
}

/// @nodoc
class __$$AccountFieldImplCopyWithImpl<$Res>
    extends _$AccountFieldCopyWithImpl<$Res, _$AccountFieldImpl>
    implements _$$AccountFieldImplCopyWith<$Res> {
  __$$AccountFieldImplCopyWithImpl(
      _$AccountFieldImpl _value, $Res Function(_$AccountFieldImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? data = null,
    Object? visible = null,
  }) {
    return _then(_$AccountFieldImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountFieldImpl implements _AccountField {
  _$AccountFieldImpl(
      {@JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'data') required this.data,
      @JsonKey(name: 'visible') this.visible = true});

  factory _$AccountFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountFieldImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  String name;
  @override
  @JsonKey(name: 'data')
  String data;
  @override
  @JsonKey(name: 'visible')
  bool visible;

  @override
  String toString() {
    return 'AccountField(name: $name, data: $data, visible: $visible)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountFieldImplCopyWith<_$AccountFieldImpl> get copyWith =>
      __$$AccountFieldImplCopyWithImpl<_$AccountFieldImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountFieldImplToJson(
      this,
    );
  }
}

abstract class _AccountField implements AccountField {
  factory _AccountField(
      {@JsonKey(name: 'name') required String name,
      @JsonKey(name: 'data') required String data,
      @JsonKey(name: 'visible') bool visible}) = _$AccountFieldImpl;

  factory _AccountField.fromJson(Map<String, dynamic> json) =
      _$AccountFieldImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'name')
  set name(String value);
  @override
  @JsonKey(name: 'data')
  String get data;
  @JsonKey(name: 'data')
  set data(String value);
  @override
  @JsonKey(name: 'visible')
  bool get visible;
  @JsonKey(name: 'visible')
  set visible(bool value);
  @override
  @JsonKey(ignore: true)
  _$$AccountFieldImplCopyWith<_$AccountFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImageSource _$ImageSourceFromJson(Map<String, dynamic> json) {
  return _ImageSource.fromJson(json);
}

/// @nodoc
mixin _$ImageSource {
  @JsonKey(name: 'path')
  String get path => throw _privateConstructorUsedError;
  @JsonKey(name: 'path')
  set path(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'source')
  ImageSourceType get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'source')
  set source(ImageSourceType value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageSourceCopyWith<ImageSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageSourceCopyWith<$Res> {
  factory $ImageSourceCopyWith(
          ImageSource value, $Res Function(ImageSource) then) =
      _$ImageSourceCopyWithImpl<$Res, ImageSource>;
  @useResult
  $Res call(
      {@JsonKey(name: 'path') String path,
      @JsonKey(name: 'source') ImageSourceType source});
}

/// @nodoc
class _$ImageSourceCopyWithImpl<$Res, $Val extends ImageSource>
    implements $ImageSourceCopyWith<$Res> {
  _$ImageSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? source = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ImageSourceType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageSourceImplCopyWith<$Res>
    implements $ImageSourceCopyWith<$Res> {
  factory _$$ImageSourceImplCopyWith(
          _$ImageSourceImpl value, $Res Function(_$ImageSourceImpl) then) =
      __$$ImageSourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'path') String path,
      @JsonKey(name: 'source') ImageSourceType source});
}

/// @nodoc
class __$$ImageSourceImplCopyWithImpl<$Res>
    extends _$ImageSourceCopyWithImpl<$Res, _$ImageSourceImpl>
    implements _$$ImageSourceImplCopyWith<$Res> {
  __$$ImageSourceImplCopyWithImpl(
      _$ImageSourceImpl _value, $Res Function(_$ImageSourceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? source = null,
  }) {
    return _then(_$ImageSourceImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ImageSourceType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageSourceImpl implements _ImageSource {
  _$ImageSourceImpl(
      {@JsonKey(name: 'path') required this.path,
      @JsonKey(name: 'source') required this.source});

  factory _$ImageSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageSourceImplFromJson(json);

  @override
  @JsonKey(name: 'path')
  String path;
  @override
  @JsonKey(name: 'source')
  ImageSourceType source;

  @override
  String toString() {
    return 'ImageSource(path: $path, source: $source)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageSourceImplCopyWith<_$ImageSourceImpl> get copyWith =>
      __$$ImageSourceImplCopyWithImpl<_$ImageSourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageSourceImplToJson(
      this,
    );
  }
}

abstract class _ImageSource implements ImageSource {
  factory _ImageSource(
          {@JsonKey(name: 'path') required String path,
          @JsonKey(name: 'source') required ImageSourceType source}) =
      _$ImageSourceImpl;

  factory _ImageSource.fromJson(Map<String, dynamic> json) =
      _$ImageSourceImpl.fromJson;

  @override
  @JsonKey(name: 'path')
  String get path;
  @JsonKey(name: 'path')
  set path(String value);
  @override
  @JsonKey(name: 'source')
  ImageSourceType get source;
  @JsonKey(name: 'source')
  set source(ImageSourceType value);
  @override
  @JsonKey(ignore: true)
  _$$ImageSourceImplCopyWith<_$ImageSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
