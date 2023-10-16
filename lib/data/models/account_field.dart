import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_field.freezed.dart';
part 'account_field.g.dart';

@unfreezed
class AccountField with _$AccountField {
  factory AccountField(
      {@JsonKey(name: 'name') required String name,
      @JsonKey(name: 'data') required String data,
      @JsonKey(name: 'visible') required bool visible}) = _AccountField;

  factory AccountField.fromJson(Map<String, dynamic> json) =>
      _$AccountFieldFromJson(json);
}
