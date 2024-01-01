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

showQuickAlertDialog(BuildContext context, AlertMessage alertMessage) {
  QuickAlert.show(
      context: context,
      type: alertMessage.type,
      title: alertMessage.text,
      confirmBtnText: alertMessage.confirmBtnText,
      cancelBtnText: alertMessage.cancelBtnText ?? 'Cancelar',
      onConfirmBtnTap: alertMessage.onConfirm ?? () => context.pop(),
      onCancelBtnTap: alertMessage.onCancel);
}
