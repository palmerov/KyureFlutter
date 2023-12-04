import 'package:freezed_annotation/freezed_annotation.dart';

part 'vault_data.freezed.dart';
part 'vault_data.g.dart';

@unfreezed
class VaultData with _$VaultData {
  factory VaultData({
    @JsonKey(name: 'accounts_data') required List<AccountGroup> accountGroups,
  }) = _VaultData;

  factory VaultData.fromJson(Map<String, dynamic> json) =>
      _$VaultDataFromJson(json);
}

@unfreezed
class AccountGroup with _$AccountGroup {
  factory AccountGroup(
          {@JsonKey(name: 'icon') required String iconName,
          @JsonKey(name: 'name') required String name,
          @JsonKey(name: 'color') required int color,
          @JsonKey(name: 'accounts') required List<Account> accounts}) =
      _AccountGroup;

  factory AccountGroup.fromJson(Map<String, dynamic> json) =>
      _$AccountGroupFromJson(json);
}

@unfreezed
class Account with _$Account {
  factory Account({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'image') required AccountImage image,
    @JsonKey(name: 'username') required AccountField fieldUsername,
    @JsonKey(name: 'password') required AccountField fieldPassword,
    @JsonKey(name: 'fields') List<AccountField>? fieldList,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

@unfreezed
class AccountField with _$AccountField {
  factory AccountField(
      {@JsonKey(name: 'name') required String name,
      @JsonKey(name: 'data') required String data,
      @JsonKey(name: 'visible') @Default(true) bool visible}) = _AccountField;

  factory AccountField.fromJson(Map<String, dynamic> json) =>
      _$AccountFieldFromJson(json);
}

@unfreezed
class AccountImage with _$AccountImage {
  factory AccountImage({
    @JsonKey(name: 'path') required String path,
    @JsonKey(name: 'source') required ImageSource source,
  }) = _AccountImage;

  factory AccountImage.fromJson(Map<String, dynamic> json) =>
      _$AccountImageFromJson(json);
}

enum ImageSource {
  assets,
  network,
  file;

  factory ImageSource.fromJson(String json) {
    switch (json) {
      case 'assets':
        return ImageSource.assets;
      case 'network':
        return ImageSource.network;
      case 'file':
        return ImageSource.file;
    }
    return ImageSource.assets;
  }

  String toJson() {
    switch (this) {
      case ImageSource.assets:
        return 'assets';
      case ImageSource.network:
        return 'network';
      case ImageSource.file:
        return 'file';
    }
  }
}
