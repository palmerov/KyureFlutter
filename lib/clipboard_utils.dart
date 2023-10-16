import 'package:flutter/services.dart';

class ClipboardUtils {
  static copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
