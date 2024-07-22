import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/version/merge_map.dart';

class VaultVersionSystemService {
  Future<(VaultData, UpdateDirection)> getMergedData(
      VaultData vdLocal, VaultData vdRemote) async {
    final vdMerged = _mergeVault(vdLocal, vdRemote);
    if (vdMerged.modifDate == vdLocal.modifDate &&
        vdMerged.modifDate == vdRemote.modifDate) {
      return (vdMerged, UpdateDirection.noUpdate);
    } else if (vdMerged.modifDate == vdLocal.modifDate) {
      return (vdMerged, UpdateDirection.toRemote);
    } else if (vdMerged.modifDate == vdRemote.modifDate) {
      return (vdMerged, UpdateDirection.toLocal);
    } else {
      return (vdMerged, UpdateDirection.toRemoteAndLocal);
    }
  }

  VaultData _mergeVault(VaultData vdA, VaultData vdB) {
    bool mergedFromA = false, mergedFromB = false;
    VaultData vdMerged = VaultData(
      accounts: {},
      deletedAccounts: {},
      groups: {},
      deletedGroups: {},
      sort: vdA.sort,
      modifDate: vdA.modifDate,
    );

    // Merging groups
    MergeMap<int, AccountGroup> mergeMapGroups =
        MergeMap(getUpTodate: (aValue, bValue) {
      if (aValue.modifDate.isAfter(bValue.modifDate)) {
        return (aValue, MergeSource.srcA);
      } else if (bValue.modifDate.isAfter(aValue.modifDate)) {
        return (bValue, MergeSource.srcB);
      }
      return (aValue, MergeSource.srcAny);
    });
    mergeMapGroups
      ..addAllInA(vdA.groups)
      ..addAllInA(vdA.deletedGroups);
    mergeMapGroups
      ..addAllInB(vdB.groups)
      ..addAllInB(vdB.deletedGroups);
    final mergedMapGroups = mergeMapGroups.getMerged();
    for (var group in mergedMapGroups.values) {
      if (group.status == LifeStatus.active) {
        vdMerged.groups[group.id] = group;
      } else {
        vdMerged.deletedGroups[group.id] = group;
      }
    }
    mergedFromA = mergeMapGroups.isMergedfromA;
    mergedFromB = mergeMapGroups.isMergedfromB;

    // Merging Accounts
    MergeMap<int, Account> mergeMapAccounts =
        MergeMap(getUpTodate: (aValue, bValue) {
      if (aValue.modifDate.isAfter(bValue.modifDate)) {
        return (aValue, MergeSource.srcA);
      } else if (bValue.modifDate.isAfter(aValue.modifDate)) {
        return (bValue, MergeSource.srcB);
      } else {
        return (aValue, MergeSource.srcAny);
      }
    });
    mergeMapAccounts
      ..addAllInA(vdA.accounts)
      ..addAllInA(vdA.deletedAccounts);
    mergeMapAccounts
      ..addAllInB(vdB.accounts)
      ..addAllInB(vdB.deletedAccounts);
    final mergedMapAccounts = mergeMapAccounts.getMerged();
    for (var account in mergedMapAccounts.values) {
      if (account.status == LifeStatus.active) {
        vdMerged.accounts[account.id] = account;
      } else {
        vdMerged.deletedAccounts[account.id] = account;
      }
    }
    mergedFromA = (mergedFromA || mergeMapAccounts.isMergedfromA);
    mergedFromB = (mergedFromB || mergeMapAccounts.isMergedfromB);

    if (mergedFromA && mergedFromB) {
      vdMerged.modifDate = DateTime.now();
    } else if (mergedFromA) {
      vdMerged.modifDate = vdA.modifDate;
    } else {
      vdMerged.modifDate = vdB.modifDate;
    }
    return vdMerged;
  }
}

enum UpdateDirection { toRemoteAndLocal, toRemote, toLocal, noUpdate }
