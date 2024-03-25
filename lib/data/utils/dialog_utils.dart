import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

class AlertMessage {
  final QuickAlertType type;
  final String text;
  final String confirmBtnText;
  final String? cancelBtnText;
  final void Function()? onConfirm;
  final void Function()? onCancel;

  AlertMessage({
    required this.type,
    required this.text,
    required this.confirmBtnText,
    this.cancelBtnText,
    this.onConfirm,
    this.onCancel,
  });
}

extension AlertDialogExtension on BuildContext {
  showQuickAlertDialog(AlertMessage alertMessage) {
    QuickAlert.show(
        context: this,
        type: alertMessage.type,
        title: alertMessage.text,
        confirmBtnText: alertMessage.confirmBtnText,
        cancelBtnText: alertMessage.cancelBtnText ?? 'Cancelar',
        onConfirmBtnTap: alertMessage.onConfirm ?? () => pop(),
        onCancelBtnTap: alertMessage.onCancel);
  }
}
