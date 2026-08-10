import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';

class AppThemeColor extends ThemeExtension<AppThemeColor> {
  // Color properties
  final Color surfacePrimary;
  final Color button;
  final Color button1;
  final Color button2;
  final Color button3;
  final Color button4;
  final Color button5;
  final Color text;
  final Color text1;
  final Color text2;
  final Color text3;
  final Color text4;
  final Color stroke;
  final Color stroke1;
  final Color stroke2;
  final Color stroke3;
  final Color stroke4;
  final Color icon;
  final Color icon1;
  final Color icon2;
  final Color icon3;
  final Color icon4;
  final Color cart;
  final Color cart1;
  final Color cart2;
  final Color cart3;
  final Color cart4;
  final Color tabbarText;
  

  const AppThemeColor({
    // Required properties for color
    required this.surfacePrimary,
    required this.button,
    required this.button1,
    required this.button2,
    required this.button3,
    required this.button4,
    required this.button5,
    required this.text,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.stroke,
    required this.stroke1,
    required this.stroke2,
    required this.stroke3,
    required this.stroke4,
    required this.icon,
    required this.icon1,
    required this.icon2,
    required this.icon3,
    required this.icon4,
    required this.cart,
    required this.cart1,
    required this.cart2,
    required this.cart3,
    required this.cart4,
    required this.tabbarText,
  });

  @override
  AppThemeColor copyWith({
    // Optional color properties for modification
    Color? surfacePrimary,
    Color? button,
    Color? button1,
    Color? button2,
    Color? button3,
    Color? button4,
    Color? button5,
    Color? text,
    Color? text1,
    Color? text2,
    Color? text3,
    Color? text4,
    Color? stroke,
    Color? stroke1,
    Color? stroke2,
    Color? stroke3,
    Color? stroke4,
    Color? icon,
    Color? icon1,
    Color? icon2,
    Color? icon3,
    Color? icon4,
    Color? cart,
    Color? cart1,
    Color? cart2,
    Color? cart3,
    Color? cart4,
    Color? tabbarText,
  }) {
    return AppThemeColor(
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      button: button ?? this.button,
      button1: button1 ?? this.button1,
      button2: button2 ?? this.button2,
      button3: button3 ?? this.button3,
      button4: button4 ?? this.button4,
      button5: button5 ?? this.button5,
      text: text ?? this.text,
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
      text4: text4 ?? this.text4,
      stroke: stroke ?? this.stroke,
      stroke1: stroke1 ?? this.stroke1,
      stroke2: stroke2 ?? this.stroke2,
      stroke3: stroke3 ?? this.stroke3,
      stroke4: stroke4 ?? this.stroke4,
      icon: icon ?? this.icon,
      icon1: icon1 ?? this.icon1,
      icon2: icon2 ?? this.icon2,
      icon3: icon3 ?? this.icon3,
      icon4: icon4 ?? this.icon4,
      cart: cart ?? this.cart,
      cart1: cart1 ?? this.cart1,
      cart2: cart2 ?? this.cart2,
      cart3: cart3 ?? this.cart3,
      cart4: cart4 ?? this.cart4,
      tabbarText: tabbarText ?? this.tabbarText,
    );
  }

  @override
  ThemeExtension<AppThemeColor> lerp(
    ThemeExtension<AppThemeColor>? other,
    double t,
  ) {
    if (other is! AppThemeColor) {
      return this;
    }
    return AppThemeColor(
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      button: Color.lerp(button, other.button, t)!,
      button1: Color.lerp(button1, other.button1, t)!,
      button2: Color.lerp(button2, other.button2, t)!,
      button3: Color.lerp(button3, other.button3, t)!,
      button4: Color.lerp(button4, other.button4, t)!,
      button5: Color.lerp(button5, other.button5, t)!,
      text: Color.lerp(text, other.text, t)!,
      text1: Color.lerp(text1, other.text1, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      text3: Color.lerp(text3, other.text3, t)!,
      text4: Color.lerp(text4, other.text4, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      stroke1: Color.lerp(stroke1, other.stroke1, t)!,
      stroke2: Color.lerp(stroke2, other.stroke2, t)!,
      stroke3: Color.lerp(stroke3, other.stroke3, t)!,
      stroke4: Color.lerp(stroke4, other.stroke4, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      icon1: Color.lerp(icon1, other.icon1, t)!,
      icon2: Color.lerp(icon2, other.icon2, t)!,
      icon3: Color.lerp(icon3, other.icon3, t)!,
      icon4: Color.lerp(icon4, other.icon4, t)!,
      cart: Color.lerp(cart, other.cart, t)!,
      cart1: Color.lerp(cart1, other.cart1, t)!,
      cart2: Color.lerp(cart2, other.cart2, t)!,
      cart3: Color.lerp(cart3, other.cart3, t)!,
      cart4: Color.lerp(cart4, other.cart4, t)!,
      tabbarText: Color.lerp(tabbarText, other.tabbarText, t)!,
    );
  }
// Light theme colors
  static const light = AppThemeColor(

    surfacePrimary: AppColor.surfacePrimaryLight,
    button: AppColor.buttonLight,
    button1: AppColor.button1Light,
    button2: AppColor.button2Light,
    button3: AppColor.button3Light,
    button4: AppColor.button4Light,
    button5: AppColor.button5Light,
    text: AppColor.textLight,
    text1: AppColor.text1Light,
    text2: AppColor.text2Light,
    text3: AppColor.text3Light,
    text4: AppColor.text4Light,
    stroke: AppColor.strokeLight,
    stroke1: AppColor.stroke1Light,
    stroke2: AppColor.stroke2Light,
    stroke3: AppColor.stroke3Light,
    stroke4: AppColor.stroke4Light,
    icon: AppColor.iconLight,
    icon1: AppColor.icon1Light,
    icon2: AppColor.icon2Light,
    icon3: AppColor.icon3Light,
    icon4: AppColor.icon4Light,
    cart: AppColor.cartLight,
    cart1: AppColor.cart1Light,
    cart2: AppColor.cart2Light,
    cart3: AppColor.cart3Light,
    cart4: AppColor.cart4Light,
    tabbarText: AppColor.tabbarTextLight,
  );

  // Dark theme colors
  static const dark = AppThemeColor(
    surfacePrimary: AppColor.surfacePrimaryDark,
    button: AppColor.buttonDark,
    button1: AppColor.button1Dark,
    button2: AppColor.button2Dark,
    button3: AppColor.button3Dark,
    button4: AppColor.button4Dark,
    button5: AppColor.button5Dark,
    text: AppColor.textDark,
    text1: AppColor.text1Dark,
    text2: AppColor.text2Dark,
    text3: AppColor.text3Dark,
    text4: AppColor.text4Dark,
    stroke: AppColor.strokeDark,
    stroke1: AppColor.stroke1Dark,
    stroke2: AppColor.stroke2Dark,
    stroke3: AppColor.stroke3Dark,
    stroke4: AppColor.stroke4Dark,
    icon: AppColor.iconDark,
    icon1: AppColor.icon1Dark,
    icon2: AppColor.icon2Dark,
    icon3: AppColor.icon3Dark,
    icon4: AppColor.icon4Dark,
    cart: AppColor.cartDark,
    cart1: AppColor.cart1Dark,
    cart2: AppColor.cart2Dark,
    cart3: AppColor.cart3Dark,
    cart4: AppColor.cart4Dark,
    tabbarText: AppColor.tabbarTextDark,
  );
}


  // Light theme instance
  



