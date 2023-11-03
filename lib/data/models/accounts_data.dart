import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounts_data.freezed.dart';
part 'accounts_data.g.dart';

@unfreezed
class AccountsData with _$AccountsData {
  factory AccountsData(
      {@JsonKey(name: 'accounts_data')
      required List<AccountGroup> accountGroups}) = _AccountsData;

  factory AccountsData.fromJson(Map<String, dynamic> json) =>
      _$AccountsDataFromJson(json);
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
    @JsonKey(name: 'name') required final String name,
    @JsonKey(name: 'image') AccountImage? image,
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
  url,
  file;

  factory ImageSource.fromJson(String json) {
    switch (json) {
      case 'assets':
        return ImageSource.assets;
      case 'url':
        return ImageSource.url;
      case 'file':
        return ImageSource.file;
    }
    return ImageSource.assets;
  }

  String toJson() {
    switch (this) {
      case ImageSource.assets:
        return 'assets';
      case ImageSource.url:
        return 'url';
      case ImageSource.file:
        return 'file';
    }
  }
}
