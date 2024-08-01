import 'dart:io';

import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';

String concatPath(String parent, String child, [bool remote = false]) {
  if (Platform.isWindows && !remote) {
    return '$parent\\$child';
  } else {
    return '$parent/$child';
  }
}

String concatPathNames(List<String> names, [bool remote = false]) {
  if (Platform.isWindows && !remote) {
    return names.fold('', (previousValue, element) => '$previousValue\\$element').substring(1);
  } else {
    return names.fold('', (previousValue, element) => '$previousValue/$element').substring(1);
  }
}

Future<Directory> getLocalInternalRootDir() async {
  if (Platform.isAndroid) {
    return await Directory(
            concatPath((await getApplicationSupportDirectory()).path, 'kiure'))
        .create(recursive: true);
  } else {
    return await Directory(concatPath(
            (await getApplicationDocumentsDirectory()).path, 'kiure'))
        .create(recursive: true);
  }
}

Future<void> shareFile(String filePath, String title, String shareText) async {
  await FlutterShare.shareFile(
    title: title,
    text: shareText,
    filePath: filePath,
  );
}
