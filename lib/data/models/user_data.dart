import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@unfreezed
class UserData with _$UserData {
  factory UserData({
    @JsonKey(name: 'version') required int version,
    @JsonKey(name: 'datacrypt') required String datacrypt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
