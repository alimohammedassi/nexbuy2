import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../localization/app_localizations.dart';

/// Utility class for showing consistent snackbars throughout the app
class SnackbarUtils {
  /// Show success snackbar
  static void showSuccess(
    BuildContext context, {
    required String title,
    String? message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        content: AwesomeSnackbarContent(
          title: title,
          message: message ?? '',
          contentType: ContentType.success,
        ),
      ),
    );
  }

  /// Show error snackbar
  static void showError(
    BuildContext context, {
    required String title,
    String? message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        content: AwesomeSnackbarContent(
          title: title,
          message: message ?? '',
          contentType: ContentType.failure,
        ),
      ),
    );
  }

  /// Show warning snackbar
  static void showWarning(
    BuildContext context, {
    required String title,
    String? message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        content: AwesomeSnackbarContent(
          title: title,
          message: message ?? '',
          contentType: ContentType.warning,
        ),
      ),
    );
  }

  /// Show info snackbar
  static void showInfo(
    BuildContext context, {
    required String title,
    String? message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        content: AwesomeSnackbarContent(
          title: title,
          message: message ?? '',
          contentType: ContentType.help,
        ),
      ),
    );
  }

  /// Show success message for adding to cart
  static void showAddedToCart(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showSuccess(
      context,
      title: localizations.addedToCart,
      message: localizations.viewCart,
    );
  }

  /// Show success message for adding to favorites
  static void showAddedToFavorites(BuildContext context) {
    showSuccess(
      context,
      title: 'Added to favorites',
      message: 'Item has been saved to your favorites',
    );
  }

  /// Show success message for removing from favorites
  static void showRemovedFromFavorites(BuildContext context) {
    showWarning(
      context,
      title: 'Removed from favorites',
      message: 'Item has been removed from your favorites',
    );
  }

  /// Show error message for login
  static void showLoginError(BuildContext context, String message) {
    showError(context, title: 'Login Failed', message: message);
  }

  /// Show success message for login
  static void showLoginSuccess(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showSuccess(context, title: localizations.loginSuccessful, message: '');
  }

  /// Show error message for signup
  static void showSignupError(BuildContext context, String message) {
    showError(context, title: 'Signup Failed', message: message);
  }

  /// Show success message for signup
  static void showSignupSuccess(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showSuccess(context, title: localizations.accountCreated, message: '');
  }
}
