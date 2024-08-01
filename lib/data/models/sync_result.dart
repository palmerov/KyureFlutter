import 'package:kyure/services/version/vault_version_system_service.dart';

enum SyncResultType { accessError, wrongRemoteKey, incompatible, success }

class SyncResult {
  final SyncResultType type;
  final UpdateDirection direction;
  String message;

  SyncResult(this.type, this.message, this.direction);

  static SyncResult accessError(String message) =>
      SyncResult(SyncResultType.accessError, message, UpdateDirection.none);

  static SyncResult wrongRemoteKey(String message) =>
      SyncResult(SyncResultType.wrongRemoteKey, message, UpdateDirection.none);

  static SyncResult incompatible(String message) =>
      SyncResult(SyncResultType.incompatible, message, UpdateDirection.none);

  static SyncResult success(String message, UpdateDirection updateDirection) =>
      SyncResult(SyncResultType.success, message, updateDirection);
}

enum KeyUpdateDirection { toRemote, toLocal, none }

class KeyConflictResolver {
  final String? key;
  final KeyUpdateDirection direction;
  final bool force;

  KeyConflictResolver(this.key, this.direction, this.force);
}
