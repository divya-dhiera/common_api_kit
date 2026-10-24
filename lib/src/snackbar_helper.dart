import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar({
  String title = "Notice",
  required String message,
  Color? color,
  int? duration,
}) {
  void show() {
    final bool isWarning = title.isEmpty || title == 'warning';
    final bool isSuccess = title == 'success';

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          color ??
          (isWarning
              ? const Color(0xffFFCC00)
              : isSuccess
              ? Colors.green
              : Colors.red),
      colorText: isWarning ? Colors.black : Colors.white,
      icon: Icon(
        isWarning
            ? Icons.warning_amber_outlined
            : isSuccess
            ? Icons.check_circle
            : Icons.error,
        color: isWarning ? Colors.black : Colors.white,
      ),
      margin: EdgeInsets.zero,
      borderRadius: 0,
      duration: Duration(seconds: duration ?? 2),
      isDismissible: true,
      shouldIconPulse: true,
      barBlur: 10,
    );
  }

  if (Get.overlayContext != null) {
    show();
  } else {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.overlayContext != null) {
        show();
      }
    });
  }
}

void showSuccessMessage({String? message, bool show = true}) {
  if (show) {
    showSnackBar(title: 'success', message: message ?? "Success");
  }
}
