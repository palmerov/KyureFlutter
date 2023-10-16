// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      @JsonKey(name: 'visible') required this.visible});

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
      @JsonKey(name: 'visible') required bool visible}) = _$AccountFieldImpl;

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
