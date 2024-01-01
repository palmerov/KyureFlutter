import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/services/version/merge_map.dart';

class VaultVersionSystemService {

  Future<(VaultData, UpdateDirection)> getMergedData(
      VaultData vdLocal, VaultData vdRemote) async {
    if (vdLocal.modifDate.isAfter(vdRemote.modifDate)) {
      // merge with local as after
      final vdMerged = _mergeVault(vdLocal, vdRemote);
      if (vdMerged.modifDate != vdLocal.modifDate) {
        // if the merged modif date != local modf date, have to update in local too
        return (vdMerged, UpdateDirection.toRemoteAndLocal);
      } else {
        // else have to update only remotely
        return (vdMerged, UpdateDirection.toRemote);
      }
    } else if (vdRemote.modifDate.isAfter(vdLocal.modifDate)) {
      // merge with remote as after
      final vdMerged = _mergeVault(vdRemote, vdLocal);
      if (vdMerged.modifDate != vdRemote.modifDate) {
        // if the merged modif date != remote modf date, have to update in remote too
        return (vdMerged, UpdateDirection.toRemoteAndLocal);
      } else {
        // else have to update only local
        return (vdMerged, UpdateDirection.toLocal);
      }
    }
    return (vdLocal, UpdateDirection.noUpdate);
  }

  VaultData _mergeVault(VaultData vdAfter, VaultData vdBefore) {
    bool mergedFromA = false, mergedFromB = false;
    VaultData vdMerged = VaultData(
      accounts: {},
      deletedAccounts: {},
      groups: {},
      deletedGroups: {},
      sort: vdAfter.sort,
      modifDate: vdAfter.modifDate,
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
      ..addAllInA(vdAfter.groups)
      ..addAllInA(vdAfter.deletedGroups);
    mergeMapGroups
      ..addAllInB(vdBefore.groups)
      ..addAllInB(vdBefore.deletedGroups);
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
        return (aValue, MergeSource.srcB);
      } else {
        return (aValue, MergeSource.srcAny);
      }
    });
    mergeMapAccounts
      ..addAllInA(vdAfter.accounts)
      ..addAllInA(vdAfter.deletedAccounts);
    mergeMapAccounts
      ..addAllInB(vdBefore.accounts)
      ..addAllInB(vdBefore.deletedAccounts);
    final mergedMapAccounts = mergeMapAccounts.getMerged();
    for (var account in mergedMapAccounts.values) {
      if (account.status == LifeStatus.active) {
        vdMerged.accounts[account.id] = account;
      } else {
        vdMerged.deletedAccounts[account.id] = account;
      }
    }
    mergedFromA = mergedFromA || mergeMapGroups.isMergedfromA;
    mergedFromB = mergedFromB || mergeMapGroups.isMergedfromB;

    if (mergedFromA && mergedFromB) {
      vdMerged.modifDate = DateTime.now();
    } else if (mergedFromA) {
      vdMerged.modifDate = vdAfter.modifDate;
    } else {
      vdMerged.modifDate = vdBefore.modifDate;
    }
    return vdMerged;
  }
}

enum UpdateDirection { toRemoteAndLocal, toRemote, toLocal, noUpdate }
