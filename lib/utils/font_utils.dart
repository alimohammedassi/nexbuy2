import 'package:flutter/material.dart';

class FontUtils {
  static String getFontFamily(BuildContext context) {
    try {
      final locale = Localizations.localeOf(context);
      
      // Use Cairo for Arabic, Poppins for English and other languages
      if (locale.languageCode == 'ar') {
        return 'Cairo';
      }
      return 'Poppins';
    } catch (e) {
      // Fallback to Poppins if localization is not available
      return 'Poppins';
    }
  }

  static TextStyle getTextStyle(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    final fontFamily = getFontFamily(context);
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // Predefined styles for common use cases
  static TextStyle heading1(BuildContext context) {
    return getTextStyle(context, fontSize: 32, fontWeight: FontWeight.bold);
  }

  static TextStyle heading2(BuildContext context) {
    return getTextStyle(context, fontSize: 24, fontWeight: FontWeight.w600);
  }

  static TextStyle heading3(BuildContext context) {
    return getTextStyle(context, fontSize: 20, fontWeight: FontWeight.w600);
  }

  static TextStyle body(BuildContext context) {
    return getTextStyle(context, fontSize: 16, fontWeight: FontWeight.normal);
  }

  static TextStyle bodySmall(BuildContext context) {
    return getTextStyle(context, fontSize: 14, fontWeight: FontWeight.normal);
  }

  static TextStyle button(BuildContext context) {
    return getTextStyle(context, fontSize: 16, fontWeight: FontWeight.w600);
  }
}
