import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'custom_apptext.dart';

class ShowCustomSnackbar {
  static void _show(
      BuildContext context, {
        required String message,
        required Color color,
        Color textColor = Colors.white,
        IconData? icon,
        Duration duration = const Duration(seconds: 3),
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackbarContent = Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 7),
        ],
        Expanded(
          child: AppText(
            message,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
      ],
    );

    final snackBar = SnackBar(
      content: snackbarContent,
      backgroundColor: color,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void success(
      BuildContext context, {
        required String message,
        IconData? icon = Icons.check_circle_outline,
      }) {
    _show(
      context,
      message: message,
      color: primaryColor,
      icon: icon,
    );
  }

  static void error(
      BuildContext context, {
        required String message,
        IconData? icon = Icons.error_outline,
      }) {
    _show(
      context,
      message: message,
      color: Colors.red.shade700,
      icon: icon,
    );
  }

  static void warning(
      BuildContext context, {
        required String message,
        IconData? icon = Icons.warning_amber_rounded,
      }) {
    _show(
      context,
      message: message,
      color: const Color(0xFFFF9800),
      icon: icon,
    );
  }
}