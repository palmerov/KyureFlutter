enum SyncResultType { accessError, wrongRemoteKey, incompatible, success }

class SyncResult {
  final SyncResultType type;
  String message;

  SyncResult(this.type, this.message);

  static SyncResult accessError(String message) =>
      SyncResult(SyncResultType.accessError, message);

  static SyncResult wrongRemoteKey(String message) =>
      SyncResult(SyncResultType.wrongRemoteKey, message);

  static SyncResult incompatible(String message) =>
      SyncResult(SyncResultType.incompatible, message);

  static SyncResult success(String message) =>
      SyncResult(SyncResultType.success, message);
}