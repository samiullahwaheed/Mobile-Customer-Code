import 'dart:io';

import 'package:loyalty_customer/screen/subscription_screen/model/stripe_checkout_model.dart';
import 'package:loyalty_customer/screen/subscription_screen/model/kuickpay_checkout_model.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http_parser/http_parser.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/service/api_service/api_services.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';
import 'package:mime/mime.dart';

class PostRepository {
  PostRepository._();
  static final PostRepository _instance = PostRepository._();
  static PostRepository get instance => _instance;



  //------------Services--------------

  final ApiServices apiServices = ApiServices.instance;

  Future<dynamic?> addCardForWallet({required String merchantId}) async {
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.addCardForWallet,
        body: {"merchantId": merchantId},
      );
      if (response != null) {
        AppPrint.apiResponse(
          response["data"]["cardId"],
          title: "addCardForWallet",
        );
        return response["data"]["cardId"];
      } else {
        return false;
      }
    } catch (e) {
      errorLog("addCardForWallet", e);
    }
    return false;
  }

  Future<bool> updateUserProfile({
    String? firstName,
    String? appId,
    String? referenceId,
    // String? email,
    String? country,
    String? city,
    String? address,
    String? latitude,
    String? longitude,
    String? profile,
    String? fcmToken,

    // 🔔 Notification Settings
    bool? promotionalEmails,
    bool? appNotifications,
    bool? smsNotifications,
    bool? referralNotifications,
    bool? subscriptionNotifications,
    bool? pushNotifications,

    List<String>? prefreances,
    String? interestedIn,
  }) async {
    try {
      // -------------------------------
      // MAIN BODY MAP
      // -------------------------------
      final Map<String, dynamic> data = {};

      void addIfValid(String key, dynamic value) {
        if (value != null) {
          if (value is String && value.isEmpty) return;
          data[key] = value;
        }
      }

      // BASIC INFO
      addIfValid("firstName", firstName);
      addIfValid("appId", appId);
      addIfValid("referenceId", referenceId);
      // addIfValid("email", email);
      addIfValid("country", country);
      addIfValid("city", city);
      addIfValid("address", address);
      addIfValid("latitude", latitude);
      addIfValid("longitude", longitude);
      addIfValid("interestedIn", interestedIn);
      addIfValid("fcmToken", fcmToken);

      // -------------------------------
      // 🔔 NOTIFICATION SETTINGS OBJECT
      // -------------------------------
      final Map<String, dynamic> notificationSettings = {};

      void addNotification(String key, bool? value) {
        if (value != null) {
          notificationSettings[key] = value;
        }
      }

      addNotification("promotionalEmails", promotionalEmails);
      addNotification("appNotifications", appNotifications);
      addNotification("smsNotifications", smsNotifications);
      addNotification("referralNotifications", referralNotifications);
      addNotification("subscriptionNotifications", subscriptionNotifications);
      addNotification("pushNotifications", pushNotifications);

      if (notificationSettings.isNotEmpty) {
        data["notificationSettings"] = notificationSettings;
      }

      // -------------------------------
      // PREFREANCES
      // -------------------------------
      if (prefreances != null && prefreances.isNotEmpty) {
        data["prefreances"] = prefreances;
      }

      // -------------------------------
      // FORM DATA
      // -------------------------------
      final FormData formData = FormData.fromMap(data);

      // -------------------------------
      // IMAGE FILE (Multipart)
      // -------------------------------
      if (profile != null && profile.isNotEmpty) {
        try {
          final file = File(profile);
          if (await file.exists()) {
            final fileName = file.path.split('/').last;
            final mimeType = lookupMimeType(file.path);

            formData.files.add(
              MapEntry(
                "profile",
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: MediaType.parse(
                    mimeType ?? "application/octet-stream",
                  ),
                ),
              ),
            );
          }
        } catch (e) {
          AppPrint.appError("❌ Image error: $e");
        }
      }

      // -------------------------------
      // API CALL
      // -------------------------------
      final response = await apiServices.apiPatchServices(
        url: AppApiEndPoint.instance.updateProfile,
        body: formData,
      );

      if (response != null) {
        AppPrint.appLog("✅ Profile updated successfully");
        return true;
      } else {
        AppPrint.appError("❌ Profile update failed");
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "updateUserProfile");
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Map<String, dynamic> body = {
        "currentPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.changePassword,
        body: body,
      );
      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "changePassword");
    }
    return false;
  }

  Future<bool> contactUs({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String message,
    required String subject,
  }) async {
    try {
      Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "message": message,
        "subject": subject,
      };
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.contactUs,
        body: body,
      );
      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "contactUs");
    }
    return false;
  }

  Future<bool> addToWallet({required String promotionId}) async {
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.addPromotionToWallet,
        body: {"promotionId": promotionId},
      );
      if (response != null) {
        // myWalletController.reloadPage();
        return true;
      }
    } catch (e) {
      AppPrint.appError(e, title: "addToWallet");
      return false;
    }
    return false;
  }

  Future<bool> addRecentViewedPromotion({required String promotionId}) async {
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.recentViewedPromotions,
        body: {"promotionId": promotionId},
      );

      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "addRecentViewedPromotion");
      return false;
    }
  }

  Future<bool> approveAndRejectRedemptionRequest({
    required String digitalCardCode,
    required String userId,
    required String sellId,
    required String endPoint,
  }) async {
    try {
      final response = await apiServices.apiPostServices(
        url:
            "${AppApiEndPoint.instance.approveAndRejectRedemptionRequest}$endPoint",
        body: {
          "digitalCardCode": digitalCardCode,
          "userId": userId,
          "sellId": sellId,
        },
      );
      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "approveAndRejectRedemptionRequest");
      return false;
    }
  }

  Future<bool> rateMerchant({
    required String digitalCardId,
    required String promotionId,
    required String merchantId,
    required double rating,
    required String comment,
  }) async {
    Map<String, dynamic> body = {
      "digitalCardId": digitalCardId,
      "promotionId": promotionId,
      "merchantId": merchantId,
      "rating": rating,
      "comment": comment,
    };
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.rateMerchant,
        body: body,
      );
      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "rateMerchant");
      return false;
    }
  }

  Future<StripeCheckoutModel?> paymentPackage({
    required String packageId,
  }) async {
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.packagePayment,
        body: {"packageId": packageId},
      );
      if (response != null) {
        AppPrint.apiResponse(response, title: "paymentPackage");
        return StripeCheckoutModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      AppPrint.appError(e, title: "paymentPackage");
      return null;
    }
  }

  Future<KuickpayCheckoutModel?> kuickpayPaymentPackage({
    required String packageId,
  }) async {
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.kuickpayPackagePayment,
        body: {"packageId": packageId},
      );
      if (response != null) {
        AppPrint.apiResponse(response, title: "kuickpayPaymentPackage");
        return KuickpayCheckoutModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      AppPrint.appError(e, title: "kuickpayPaymentPackage");
      return null;
    }
  }

  Future<bool> salesRep({required String packageId}) async {
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.salesRep,
        body: {"packageId": packageId},
      );
      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "salesRep");
      return false;
    }
  }

  Future<bool> salesRepTokenValided({required String token}) async {
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.salesRepTokenValided,
        body: {"token": token},
      );
      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "salesRepTokenValided");
      return false;
    }
  }

  Future<bool> favoriteMerchant({required String merchantId}) async {
    try {
      final response = await apiServices.apiPostServices(
        url: AppApiEndPoint.instance.favoriteMerchant,
        body: {"merchantId": merchantId},
      );
      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "favoriteMerchant");
      return false;
    }
  }
}
