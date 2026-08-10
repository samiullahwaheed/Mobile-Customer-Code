import 'dart:developer';

import 'package:flutter/foundation.dart';

class AppPrint {
 
 
  ///////////////////// app log ////////////////////////
  static void appLog(dynamic value) {
    try {
      if (kDebugMode) {
        log(""""
         😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊
         $value
         😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊
        """);
      }
    } catch (e) {
      log("error form AppLog: $e");
    }
  }
 
  static void appError(dynamic value, {String title = "error from"}) {
    try {
      if (kDebugMode) {
        log(""""
        ERROR  ❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌
        $title========> $value
        ERROR  ❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌
        """);
      }
    } catch (e) {
      log("error form AppLog: $e");
    }
  }
  static void appPrint(dynamic value, {String title = "value"}) {
    try {
      if (kDebugMode) {
        log(""""
        Print  🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕
        $title========> $value
        Print  🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕🌕
        """);
      }
    } catch (e) {
      log("error form AppLog: $e");
    }
  }
 
  static void apiResponse(dynamic value, {String title = "value"}) {
    try {
      if (kDebugMode) {
        log(""""
        Print  📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍
        $title========> $value
        Print  🌕📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍📍
        """);
      }
    } catch (e) {
      log("error form AppLog: $e");
    }
  }
}