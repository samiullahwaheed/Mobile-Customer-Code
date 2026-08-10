import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppSnackBar {
  static void _showToast({
    required String title,
    required String message,
    required Color bgColor,
    required Color textColor,
  }) {
    final context = navigatorKey.currentContext;

    if (context == null) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (title.isNotEmpty) const SizedBox(height: 4),
            Text(message, style: TextStyle(color: textColor, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  // ❌ Error Toast — RED
  static void error(String message) {
    _showToast(
      title: "Error!",
      message: message,
      bgColor: Colors.red,
      textColor: Colors.white,
    );
  }

  // ✅ Success Toast — GREEN
  static void success(String message) {
    _showToast(
      title: "Success!",
      message: message,
      bgColor: Colors.green,
      textColor: Colors.white,
    );
  }

  // 📘 Message Toast — NAVY BLUE
  static void message(String message) {
    _showToast(
      title: "",
      message: message,
      bgColor: Colors.grey.shade400, // Navy Blue
      textColor: Colors.black,
    );
  }
}
