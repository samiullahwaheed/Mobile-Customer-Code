import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_const.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    extensions: const [AppThemeColor.light],
    fontFamily:AppConst.fontFamily1,
    scaffoldBackgroundColor: AppColor.surfacePrimaryLight,
    primaryColor: AppColor.buttonLight,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColor.buttonLight,
      error: AppColor.buttonLight,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.surfacePrimaryLight,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColor.textLight,
        fontFamily: AppConst.fontFamily1,
        height: 1.6,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColor.surfacePrimaryLight,
      indicatorColor: AppColor.buttonLight,
      height: 80,
      labelTextStyle: WidgetStateTextStyle.resolveWith(
        (states) => TextStyle(
          fontWeight:
              states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.normal,
          fontSize: 12,
          color:
              states.contains(WidgetState.selected)
                  ? AppColor.buttonLight
                  : AppColor.text2Light,
        ),
      ),
    )
    );

    
  static ThemeData darkTheme = ThemeData(
    extensions: const [AppThemeColor.dark],
    fontFamily: AppConst.fontFamily1,
    scaffoldBackgroundColor: AppThemeColor.dark.surfacePrimary,
    primaryColor: AppColor.buttonDark,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColor.buttonDark,
      error: AppColor.buttonDark,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.surfacePrimaryDark,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: AppColor.textDark,
        fontFamily:AppConst.fontFamily1,
        height: 1.6,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColor.surfacePrimaryDark,
      indicatorColor: AppColor.buttonDark,
      height: 80,
      labelTextStyle: WidgetStateTextStyle.resolveWith(
        (states) => TextStyle(
          fontWeight:
              states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.normal,
          fontSize: 12,
          color:
              states.contains(WidgetState.selected)
                  ? AppColor.buttonDark
                  : AppColor.text2Dark,
        ),
      ),
    )
    );

    
}