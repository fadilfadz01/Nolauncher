import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Nolauncher';
  static const String appVersion = '1.0.1';
  static const String appBuildNumber = '1';
}

class AppFontSizes {
  static const xlargeSize = 34.0;
  static const largeSize = 32.0;
  static const mediumSize = 30.0;
  static const xMediumSize = 28.0;
  static const xxMediumSize = 26.0;
  static const smallSize = 24.0;
  static const xSmallSize = 22.0;
  static const xxSmallSize = 20.0;
  static const xxxSmallSize = 18.0;

  static const appTitleSize = xxMediumSize;
  static const appRegularSize = xxxSmallSize;

  static const allAppsSize = xMediumSize;
  static const pinnedAppsSize = xlargeSize;

  static const clockTimeSize = 60.0;
  static const clockDateSize = xMediumSize;
}

class AppBorderSizes {
  static const defaultBordersize = 12.0;
}

class AppColors {
  static const primary = Colors.black;
  static const secondary = Colors.white;
  static const tertiary = Colors.grey;
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.secondary,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.secondary,
      surface: AppColors.secondary,
      onSurface: AppColors.primary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.primary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primary),
      bodyMedium: TextStyle(color: AppColors.primary),
      bodySmall: TextStyle(color: AppColors.primary),
    ),
    iconTheme: const IconThemeData(color: AppColors.primary),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.tertiary),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primary),
        foregroundColor: WidgetStatePropertyAll(AppColors.secondary),
        overlayColor: WidgetStatePropertyAll(AppColors.tertiary),
      ),
    ),
    fontFamily: "ubuntu",
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.primary,
    primaryColor: AppColors.secondary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.secondary,
      onPrimary: AppColors.primary,
      surface: AppColors.primary,
      onSurface: AppColors.secondary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.secondary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.secondary),
      bodyMedium: TextStyle(color: AppColors.secondary),
      bodySmall: TextStyle(color: AppColors.secondary),
    ),
    iconTheme: const IconThemeData(color: AppColors.secondary),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.tertiary),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.secondary),
        foregroundColor: WidgetStatePropertyAll(AppColors.primary),
        overlayColor: WidgetStatePropertyAll(AppColors.tertiary),
      ),
    ),
    fontFamily: "ubuntu",
  );
}
