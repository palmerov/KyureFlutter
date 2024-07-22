class MergeMap<K, V> {
  MergeMap({required this.getUpTodate});
  final Map<K, V> _aMap = {}, _bMap = {};
  final Map<K, (V?, V?)> _map = {};
  final (V, MergeSource) Function(V aValue, V bValue) getUpTodate;
  bool _mergedFromB = false, _mergedFromA = false;

  void addAllInA(Map<K, V> aMap) {
    _aMap.addAll(aMap);
  }

  void addAllInB(Map<K, V> bMap) {
    _bMap.addAll(bMap);
  }

  void add(K key, V? aValue, V? bValue) {
    if (aValue != null) {
      _aMap[key] = aValue;
    }
    if (bValue != null) {
      _bMap[key] = bValue;
    }
  }

  _prepareMap() {
    _map.clear();
    for (var key in _aMap.keys) {
      _map[key] = (_aMap[key], null);
    }
    for (var key in _bMap.keys) {
      V? av, bv;
      if (_map.containsKey(key)) {
        (av, bv) = _map[key]!;
      }
      bv = _bMap[key];
      _map[key] = (av, bv);
    }
  }

  _applyMergeSource(MergeSource source) {
    switch (source) {
      case MergeSource.srcA:
        _mergedFromA = true;
        break;
      case MergeSource.srcB:
        _mergedFromB = true;
        break;
      case MergeSource.srcAny:
        break;
    }
  }

  Map<K, V> getMerged() {
    _prepareMap();
    _mergedFromA = false;
    _mergedFromB = false;
    Map<K, V> mergedMap = {};
    for (var key in _map.keys) {
      (V? av, V? bv) values = _map[key]!;
      if (values.$1 == null) {
        mergedMap[key] = values.$2 as V;
        _mergedFromB = true;
      } else if (values.$2 == null) {
        mergedMap[key] = values.$1 as V;
        _mergedFromA = true;
      } else {
        (V, MergeSource) mergeValues =
            getUpTodate(values.$1 as V, values.$2 as V);
        _applyMergeSource(mergeValues.$2);
        mergedMap[key] = mergeValues.$1;
      }
    }
    return mergedMap;
  }

  get isMergedfromA => _mergedFromA;

  get isMergedfromB => _mergedFromB;
}

enum MergeSource { srcA, srcB, srcAny }
