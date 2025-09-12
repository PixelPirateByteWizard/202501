import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DialogUtils {
  // 显示信息对话框
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = '确定',
    Color? buttonColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor ?? AppTheme.accentColor,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // 显示成功对话框
  static Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = '确定',
  }) {
    return showInfoDialog(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      buttonColor: Colors.green,
    );
  }

  // 显示错误对话框
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = '确定',
  }) {
    return showInfoDialog(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      buttonColor: Colors.red,
    );
  }

  // 显示警告对话框
  static Future<void> showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = '确定',
  }) {
    return showInfoDialog(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      buttonColor: Colors.orange,
    );
  }

  // 显示确认对话框
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '确定',
    String cancelText = '取消',
    Color? confirmColor,
    bool isDangerous = false,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightColor,
            ),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? 
                  (isDangerous ? Colors.red : AppTheme.accentColor),
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    ) ?? false;
  }

  // 显示自定义内容对话框
  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    required List<Widget> actions,
    bool scrollable = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(title),
        content: scrollable 
            ? SingleChildScrollView(child: content)
            : content,
        actions: actions,
      ),
    );
  }

  // 创建标准的确定按钮
  static Widget createConfirmButton(
    BuildContext context, {
    required VoidCallback onPressed,
    String text = '确定',
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppTheme.accentColor,
        foregroundColor: foregroundColor ?? Colors.white,
      ),
      child: Text(text),
    );
  }

  // 创建标准的取消按钮
  static Widget createCancelButton(
    BuildContext context, {
    required VoidCallback onPressed,
    String text = '取消',
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.lightColor,
      ),
      child: Text(text),
    );
  }

  // 创建危险操作按钮
  static Widget createDangerButton(
    BuildContext context, {
    required VoidCallback onPressed,
    String text = '确定',
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }

  // 创建成功按钮
  static Widget createSuccessButton(
    BuildContext context, {
    required VoidCallback onPressed,
    String text = '确定',
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }
}