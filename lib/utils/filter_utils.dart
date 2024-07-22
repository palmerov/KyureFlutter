class Filter {
  final String filter;
  late final List<String> words;

  Filter(this.filter) {
    words = filter
        .split(' ')
        .where((element) => element.isNotEmpty)
        .map((e) => simplifyString(e))
        .toList();
  }

  bool apply(String stringValue) {
    return words
            .where((element) => simplifyString(stringValue).contains(element))
            .length ==
        words.length;
  }

  static String simplifyString(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll('ü', 'u');
  }
}
