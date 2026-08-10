import 'package:dio/dio.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/service/api_service/app_in_put_unfocused.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/api_service/non_auth_api.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class AuthRepository {
  NonAuthApi nonAuthApi = NonAuthApi();
  AuthRepository._();

  static final AuthRepository _instance = AuthRepository._();
  static AuthRepository get instance => _instance;
  GetStorageServices storageServices = GetStorageServices.instance;

  Future<void> _saveAuthTokens(Map<String, dynamic> data) async {
    final accessToken = data["accessToken"]?.toString() ?? "";
    if (accessToken.isNotEmpty) {
      await storageServices.setToken(accessToken);
    }

    final refreshToken =
        data["refreshToken"]?.toString() ?? data["refresh_token"]?.toString();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await storageServices.setRefreshToken(refreshToken);
    }
  }

  String? _extractAccessToken(dynamic responseData) {
    if (responseData is! Map) return null;

    final data = responseData["data"] ?? responseData;
    if (data is! Map) return null;

    final token = data["accessToken"] ?? data["token"] ?? data["access_token"];
    return token?.toString();
  }

  Future<String?> resetToken({String? expiredAccessToken}) async {
    try {
      final storedRefreshToken = storageServices.getRefreshToken();
      final accessToken = expiredAccessToken ?? storageServices.getToken();

      final headers = <String, dynamic>{
        "Accept": "application/json",
      };
      if (accessToken.isNotEmpty) {
        headers["Authorization"] = "Bearer $accessToken";
      }

      final body = storedRefreshToken.isNotEmpty
          ? {"refreshToken": storedRefreshToken}
          : null;

      AppPrint.appLog("resetToken: calling /auth/refresh-token");

      final response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.resetToken,
        data: body,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final newAccessToken = _extractAccessToken(response.data);

        if (newAccessToken == null || newAccessToken.isEmpty) {
          AppPrint.appLog("resetToken: accessToken missing in response");
          return null;
        }

        await storageServices.setToken(newAccessToken);

        final data = response.data is Map ? response.data["data"] : null;
        if (data is Map<String, dynamic>) {
          await _saveAuthTokens(data);
        }

        AppPrint.apiResponse(newAccessToken, title: "Token Refreshed");
        return newAccessToken;
      }

      AppPrint.appLog(
        "resetToken: unexpected response ${response.statusCode}",
      );
      return null;
    } on DioException catch (e) {
      AppPrint.appLog(
        "resetToken failed: ${e.response?.statusCode} ${e.response?.data}",
      );
      errorLog("resetToken", e);
      return null;
    } catch (e) {
      errorLog("resetToken", e);
      return null;
    }
  }

  Future<dynamic> googleAuth({required String idToken}) async {
    try {
      // Keyboard / input focus remove
      appInPutUnfocused();

      // Google auth API call
      final response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.googleAuth,
        data: {"idToken": idToken},
      );

      // Check API success
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data["data"] != null) {
        final data = response.data["data"];

        // -------------------------
        // Extract required values
        // -------------------------
        String accessToken = data["accessToken"] ?? "";
        bool isFirstTimeUser = data["usesubscriptionrId"] ?? false;
        String subscription = data["subscription"] ?? "";

        await _saveAuthTokens(Map<String, dynamic>.from(data));

        AppPrint.apiResponse(accessToken, title: "Access Token Saved");

        // -------------------------
        // User first time logic
        // -------------------------
        if (!isFirstTimeUser) {
          // If subscription active
          if (subscription.isNotEmpty && subscription == "active") {
            AppPrint.apiResponse(subscription, title: "Active Subscription");
            return subscription; // go to premium flow
          } else {
            return true; // go to subscription screen
          }
        }

        // -------------------------
        // Old user → direct home
        // -------------------------

        return true;
      }

      // API response invalid
      AppPrint.apiResponse("Access Token not found!");
      return false;
    }
    // -------------------------
    // API Error Handling
    // -------------------------
    on DioException catch (error) {
      AppSnackBar.error(
        error.response?.data["message"] ?? "Something went wrong",
      );
      return false;
    }
    // -------------------------
    // Unknown error
    // -------------------------
    catch (e) {
      errorLog("googleAuth", e);
      return false;
    }
  }

  Future<dynamic> login({
    required String email,
    required String password,
    required String device,
  }) async {
    try {
      Map<String, String> body = {
        "identifier": email,
        "password": password,
        "device": device,
      };
      appInPutUnfocused();
      var response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.login,
        data: body,
      );
      AppPrint.apiResponse(
        response.data["data"]["accessToken"],
        title: "Store Token",
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = Map<String, dynamic>.from(response.data["data"]);
        await _saveAuthTokens(data);
        return data;
      } else {
        // Handle the error if the response or data is null
        AppPrint.apiResponse("Error: Access Token not found!");
      }

      return false;
    } on DioException catch (error) {
      if (error.response?.data["message"].runtimeType != null) {
        AppSnackBar.error(
          "${error.response?.data["message"] ?? "Something went wrong"}",
        );
      }
      return false;
    } catch (e) {
      errorLog("login", e);
      return false;
    }
  }

  Future<bool> resendPhoneOtp({required String phone}) async {
    Map<String, String> body = {"identifier": phone};
    try {
      var response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.resendPhone,
        data: body,
      );
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 400) {
        AppSnackBar.error(
          "${response.data["message"] ?? "Something went wrong"}",
        );
      }
    } catch (e) {
      AppPrint.appError(e, title: "ResendOtp");
    }
    return false;
  }

  Future<bool> forgetPassword({required String phone}) async {
    Map<String, String> body = {"identifier": phone};
    try {
      var response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.forgotPassword,
        data: body,
      );
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 400) {
        AppSnackBar.error(
          "${response.data["message"] ?? "Something went wrong"}",
        );
      }
    } catch (e) {
      AppPrint.appError(e, title: "ResendOtp");
    }
    return false;
  }

  Future<bool> signUp({
    required String phone,
    required String name,
    required String email,
    required String country,
    required String city,
    required String password,
    String? referenceId,
    required String role,
  }) async {
    try {
      Map<String, String> body = {
        "firstName": name,
        "phone": phone,
        "email": email,
        "country": country,
        "city": city,
        "password": password,
        "role": role,
      };

      // Add referenceId only if not empty
      if (referenceId != null && referenceId.trim().isNotEmpty) {
        body["referredId"] = referenceId;
      }

      appInPutUnfocused();

      var response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.signUp,
        data: body,
      );

      AppPrint.apiResponse(response);

      if (response.statusCode == 200) {
        appInPutUnfocused();
        return true;
      } else {
        // Handle all non-200 status codes
        appInPutUnfocused();

        // Extract error message from API response
        String errorMessage = "Something went wrong";

        // Check for errorMessages array
        if (response.data != null && response.data is Map) {
          if (response.data["errorMessages"] != null &&
              response.data["errorMessages"] is List &&
              response.data["errorMessages"].isNotEmpty) {
            errorMessage =
                response.data["errorMessages"][0]["message"] ??
                response.data["errorMessages"][0] ??
                errorMessage;
          }
          // Check for direct message field
          else if (response.data["message"] != null) {
            errorMessage = response.data["message"];
          }
          // Check for error field
          else if (response.data["error"] != null) {
            errorMessage = response.data["error"];
          }
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "SignUp failed with status ${response.statusCode}: $errorMessage",
        );
        return false;
      }
    } on DioException catch (error) {
      appInPutUnfocused();

      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        // Check different error message formats
        if (responseData is Map) {
          // Check for errorMessages array
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          }
          // Check for direct message field
          else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          }
          // Check for error field
          else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "SignUp DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        // Network error or other issues
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("SignUp DioException: ${error.message}");
      }

      return false;
    } catch (e) {
      appInPutUnfocused();
      errorLog("signUp", e);
      AppSnackBar.error("An unexpected error occurred");
      return false;
    }
  }

  Future<bool> phoneVerify({required String phone, required String otp}) async {
    Map<String, dynamic> body = {"identifier": phone, "oneTimeCode": otp};
    try {
      var response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.verifyPhone,
        data: body,
      );
      if (response.statusCode == 200 && response.data["data"] != null) {
        return true;
      } else if (response.statusCode == 400) {
        AppSnackBar.error(response.data["message"]);
      } else {
        AppPrint.apiResponse("Error: Access Token not found!");
      }

      return false;
    } catch (e) {
      AppPrint.appError(e.toString(), title: "phone Verify");
    }
    return false;
  }

  Future<dynamic> forgetPassphoneVerify({
    required String phone,
    required String otp,
  }) async {
    Map<String, dynamic> body = {"identifier": phone, "oneTimeCode": otp};
    try {
      var response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.verifyPhone,
        data: body,
      );
      if (response.statusCode == 200 && response.data["data"] != null) {
        String resetToken = response.data["data"]["resetToken"];

        return resetToken;
      } else if (response.statusCode == 400) {
        AppSnackBar.error(response.data["message"]);
      } else {
        AppPrint.apiResponse("Error: Access Token not found!");
      }

      return false;
    } catch (e) {
      AppPrint.appError(e.toString(), title: "phone Verify");
    }
    return false;
  }

  Future<bool> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String resetToken,
  }) async {
    try {
      appInPutUnfocused();
      Map body = {
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
      var response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.resetPassword,
        data: body,
        options: Options(
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
          headers: {"Accept": "application/json", "Authorization": resetToken},
        ),
      );

      if (response.statusCode == 200) {
        AppPrint.appLog("confirm password repository response :: $response");
        return true;
      }
      return false;
    } on DioException catch (error) {
      if (error.response?.data["message"].runtimeType != Null) {
        AppSnackBar.error(
          "${error.response?.data["message"] ?? "Something was wrong"}",
        );
      }
      return false;
    } catch (e) {
      errorLog("resetPassword", e);
      return false;
    }
  }

  Future<bool> referralVerify({required String ref}) async {
    AppPrint.apiResponse("referralVerify", title: "referralVerify");
    try {
      final response = await nonAuthApi.sendRequest.post(
        AppApiEndPoint.instance.referralVerify,
        data: {"referralId": ref},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "referralVerify");
      return false;
    }
  }
}
