import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/routes/app_routes_file.dart';
import 'package:loyalty_customer/const/app_theme.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppSize.size = MediaQuery.of(context).size;

    // Get saved theme mode from storage
    final GetStorageServices storage = GetStorageServices.instance;
    final bool? savedThemeMode = storage.getThemeMode();

    // Determine theme mode based on priority:
    // 1. If user has saved preference, use that
    // 2. Otherwise, use system theme
    final ThemeMode themeMode;
    if (savedThemeMode != null) {
      // User has explicitly set a theme preference
      themeMode = savedThemeMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      // No saved preference, use system theme
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      themeMode = brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
    }

    return GetMaterialApp(
      navigatorKey: navigatorKey, // Add this line to connect the navigatorKey
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // initialRoute: AppRoutes.instance.mySubScreen,
      initialRoute: AppRoutes.instance.initial,
      // initialRoute: AppRoutes.instance.confirmScreen,
      getPages: appRootRoutesFile,
      enableLog: true,
      defaultTransition: Transition.native,
      transitionDuration: Duration(milliseconds: 300),
      themeMode: themeMode, // Set initial theme mode from storage or system
      // initialBinding: AppBinding(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
