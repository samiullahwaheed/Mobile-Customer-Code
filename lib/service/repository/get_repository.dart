import 'package:dio/dio.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/model/merchant_tiar_model.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/model/sell_requist_model.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/model/my_gift_card_model.dart';
import 'package:loyalty_customer/screen/home_screen/model/merchent_model.dart';
import 'package:loyalty_customer/screen/home_screen/model/near_by_merchent_model.dart';
import 'package:loyalty_customer/screen/home_screen/model/promotion_model.dart';
import 'package:loyalty_customer/screen/home_screen/model/subscription_summery_model.dart';
import 'package:loyalty_customer/screen/merchants_screen/model/all_merchant_model.dart';
import 'package:loyalty_customer/screen/my_gift_card_screen/model/transaction_history_model.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/model/digital_card_model.dart';
import 'package:loyalty_customer/screen/notification_screen/model/notification_model.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/model/profile_model.dart';
import 'package:loyalty_customer/screen/reffer_friend_list_screen/model/referral_summary_model.dart';
import 'package:loyalty_customer/screen/show_details_screen/model/merchant_details_model.dart';
import 'package:loyalty_customer/screen/show_details_screen/model/tiar_model.dart';
import 'package:loyalty_customer/screen/subscription_screen/model/package_list_model.dart';
import 'package:loyalty_customer/screen/transaction_history_screen/model/transection_history_model.dart';
import 'package:loyalty_customer/service/api_service/api_services.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class GetRepository {
  GetRepository._();
  static final GetRepository _instance = GetRepository._();
  static GetRepository get instance => _instance;

  ApiServices apiServices = ApiServices.instance;

  //--------------Profile Section--------------

  Future<SellRequistModel?> getSellRequist() async {
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.sellRequist,
      );
      if (response != null) {
        return SellRequistModel.fromJson(response);
      } else {
        AppPrint.appError(response);
        AppSnackBar.error("Failed to load sell requist");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";
      errorLog("getSellRequist", error);
      AppSnackBar.error(errorMessage);
      AppPrint.appError(error, title: "Get Sell Requist Error");
    } catch (e) {
      errorLog("getSellRequist", e);
    }
    return null;
  }

  Future<ProfileModelData?> getProfile() async {
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.getProfile,
      );

      if (response != null) {
        if (response['data'] != null && response['data'] is Map) {
          return ProfileModelData.fromJson(response['data']);
        } else {
          AppPrint.appError(response['data']);
          AppSnackBar.error("Failed to load profile data");
        }
      } else {
        AppSnackBar.error("No response received");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Profile DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get Profile DioException: ${error.message}");
      }
    } catch (e) {
      errorLog("getProfile", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Profile Error");
    }
    return null;
  }
  //--------------merchant  Section--------------

  Future<MerchantTiarModelData?> getMerchantTiar({
    required String merchantId,
  }) async {
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.merchantTier,
        body: {"merchantId": merchantId},
      );

      if (response != null) {
        if (response['data'] != null && response['data'] is Map) {
          return MerchantTiarModelData.fromJson(response['data']);
        } else {
          AppPrint.appError(response['data']);
          AppSnackBar.error("Failed to load merchant tier data");
        }
      } else {
        AppSnackBar.error("No response received");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Merchant Tier DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get Merchant Tier DioException: ${error.message}");
      }
    } catch (e) {
      errorLog("getMerchantTiar", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Merchant Tier Error");
    }
    return null;
  }

  Future<MerchantDetailsModelData?> getMerchantDetails({
    required String merchantId,
  }) async {
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.merchantDetails(merchantId),
      );

      if (response != null) {
        if (response['data'] != null && response['data'] is Map) {
          return MerchantDetailsModelData.fromJson(response['data']);
        } else {
          AppPrint.appError(response['data']);
          AppSnackBar.error("Failed to load merchant details");
        }
      } else {
        AppSnackBar.error("No response received");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Merchant Details DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Merchant Details DioException: ${error.message}",
        );
      }
    } catch (e) {
      errorLog("getMerchantDetails", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Merchant Details Error");
    }
    return null;
  }

  Future<List<TransactionHistoryModelData>> getTransactionHistory({
    required String? digitalCardId,
    required String? type,
  }) async {
    List<TransactionHistoryModelData> transactionHistoryList =
    <TransactionHistoryModelData>[];
    Map<String, dynamic> data = {};
    if (digitalCardId != null) {
      data["digitalCardId"] = digitalCardId;
    }
    if (type != null) {
      data["type"] = type;
    }
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.transactionHistory,
        queryParameters: data,
      );
      if (response != null) {
        if (response["data"] != null && response["data"] is List) {
          for (var item in response["data"]) {
            transactionHistoryList.add(
              TransactionHistoryModelData.fromJson(item),
            );
          }
        } else {
          AppSnackBar.error("Failed to load transaction history");
        }
      } else {
        AppSnackBar.error("No response received");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Transaction History DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Transaction History DioException: ${error.message}",
        );
      }
    } catch (e) {
      errorLog("getTransactionHistory", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Transaction History Error");
    }
    return transactionHistoryList;
  }

  //--------------Promotion Section--------------
  Future<List<Promotion>> getPromotion(int limit, int page) async {
    List<Promotion> promotionList = <Promotion>[];
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.promotion(limit, page),
      );
      if (response != null && response["data"] != null) {
        AppPrint.apiResponse(response["data"], title: "Get Promotion Response");
        AppPrint.apiResponse(response["data"], title: "Get Promotion ONLY");
        for (var promotion in response["data"]) {
          promotionList.add(Promotion.fromJson(promotion));
        }
        return promotionList;
      } else {
        AppPrint.appError(response["data"], title: "Get Promotion Error");
        AppSnackBar.error("Failed to load promotions");
        return promotionList;
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Promotion DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get Promotion DioException: ${error.message}");
      }
      return promotionList;
    } catch (e) {
      errorLog("getPromotion", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Promotion Error");
      return promotionList;
    }
  }

  Future<List<Promotion>> getRecentViewPromotion() async {
    List<Promotion> recentPromotionList = <Promotion>[];
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.recentViewedPromotions,
      );
      if (response != null && response["data"] != null) {
        AppPrint.apiResponse(response["data"], title: "Get Promotion Response");
        AppPrint.apiResponse(response["data"], title: "Get Promotion ONLY");
        for (var promotion in response["data"]) {
          recentPromotionList.add(Promotion.fromJson(promotion));
        }
      } else {
        AppPrint.appError(response["data"], title: "Get Promotion Error");
        AppSnackBar.error("Failed to load recent promotions");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Recent Promotion DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Recent Promotion DioException: ${error.message}",
        );
      }
    } catch (e) {
      errorLog("getRecentViewPromotion", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Recent Promotion Error");
    }
    return recentPromotionList;
  }

  Future<List<Promotion>> getSpecificPromotion({
    required String categoryName,
  }) async {
    Map<String, dynamic> data = {};
    List<Promotion> specificPromotionList = <Promotion>[];

    if (categoryName.isNotEmpty) {
      data["categoryName"] = categoryName;
    }
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.specificPromotionList,
        queryParameters: data,
      );
      if (response != null && response["data"] != null) {
        AppPrint.apiResponse(
          response["data"],
          title: "Get Specific Promotion Response",
        );

        for (var promotion in response["data"]) {
          specificPromotionList.add(Promotion.fromJson(promotion));
        }
      } else {
        AppPrint.appError(response["data"], title: "Get Promotion Error");
        AppSnackBar.error("Failed to load specific promotions");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Specific Promotion DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Specific Promotion DioException: ${error.message}",
        );
      }
    } catch (e) {
      errorLog("getSpecificPromotion", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Specific Promotion Error");
    }
    return specificPromotionList;
  }

  //--------------Merchant Section--------------
  Future<List<MerchantModelData>> getMerchant(int limit, int page) async {
    List<MerchantModelData> merchantList = <MerchantModelData>[];
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.merchant,
      );
      if (response != null && response["data"] != null) {
        AppPrint.apiResponse(response["data"], title: "Get Merchant Response");

        for (var promotion in response["data"]) {
          merchantList.add(MerchantModelData.fromJson(promotion));
        }
        return merchantList;
      } else {
        AppPrint.appError(response["data"], title: "Get Merchant Error");
        AppSnackBar.error("Failed to load merchants");
        return merchantList;
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Merchant DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get Merchant DioException: ${error.message}");
      }
      return merchantList;
    } catch (e) {
      errorLog("getMerchant", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Merchant Error");
      return merchantList;
    }
  }

  Future<List<AllMerchantModelData>> getAllMerchant({
    required int limit,
    required int page,
    required String search,
    String? address,
    String? service,
    bool? favorite,
    String? radius,
  }) async {
    final Map<String, dynamic> data = {};

    void addIfValid(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        data[key] = value;
      }
    }

    addIfValid("limit", limit);
    addIfValid("page", page);
    addIfValid("searchTerm", search);
    addIfValid("address", address);
    addIfValid("service", service);
    addIfValid("radius", radius);
    addIfValid("favorite", favorite);

    List<AllMerchantModelData> merchantList = <AllMerchantModelData>[];

    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.merchantAll,
        queryParameters: data,
      );
      if (response != null) {
        AppPrint.apiResponse(
          response["data"],
          title: "Get All Merchant Response",
        );

        if (response["data"] != null && response["data"] is List) {
          for (var merchant in response["data"]) {
            merchantList.add(AllMerchantModelData.fromJson(merchant));
            AppPrint.apiResponse(merchant, title: "Get All Merchant Response");
          }
        } else {
          AppSnackBar.error("Failed to load all merchants");
        }
      } else {
        AppPrint.appError(response["data"], title: "Get All Merchant Error");
        AppSnackBar.error("No response received");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get All Merchant DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get All Merchant DioException: ${error.message}");
      }
    } catch (e) {
      errorLog("getAllMerchant", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get All Merchant Error");
    }
    return merchantList;
  }

  //--------------Digital Card Section--------------
  Future<List<DigitalCard>> getDigitalCard({
    int? limit,
    int? page,
    String? search,
  }) async {
    Map<String, dynamic> data = {};
    if (limit != null) {
      data["limit"] = limit;
    }
    if (page != null) {
      data["page"] = page;
    }
    if (search != null) {
      data["searchTerm"] = search;
    }
    List<DigitalCard> digitalCardList = <DigitalCard>[];
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.digitalCard,
        queryParameters: data,
      );

      // Log full response for debugging
      AppPrint.apiResponse(response, title: "Get Digital Card Full Response");

      if (response != null) {
        // Check if response has "data" key
        if (response["data"] != null) {
          AppPrint.apiResponse(
            response["data"],
            title: "Get Digital Card Data",
          );

          // Check if digitalCards exists and is a list
          if (response["data"]["digitalCards"] != null &&
              response["data"]["digitalCards"] is List) {
            AppPrint.apiResponse(
              response["data"]["digitalCards"],
              title: "Get Digital Card List",
            );

            for (var digitalCard in response["data"]["digitalCards"]) {
              try {
                digitalCardList.add(DigitalCard.fromJson(digitalCard));
              } catch (e) {
                AppPrint.appError(e, title: "Digital Card Parse Error");
              }
            }
            return digitalCardList;
          } else {
            AppPrint.appError(
              "digitalCards is null or not a list",
              title: "Get Digital Card Error",
            );
            AppSnackBar.error("Failed to load digital cards");
            return digitalCardList;
          }
        } else {
          AppPrint.appError(
            "Response data is null",
            title: "Get Digital Card Error",
          );
          AppPrint.apiResponse(
            response,
            title: "Full Response Without Data Key",
          );
          AppSnackBar.error("Invalid response format");
          return digitalCardList;
        }
      } else {
        AppPrint.appError(
          "API response is null",
          title: "Get Digital Card Error",
        );
        AppSnackBar.error("No response received");
        return digitalCardList;
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Digital Card DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get Digital Card DioException: ${error.message}");
      }
      return digitalCardList;
    } catch (e) {
      errorLog("getDigitalCard", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Digital Card Error");
      return digitalCardList;
    }
  }

  // //--------------My Gift Card Section--------------
  //--------------My Gift Card Section--------------
  Future<List<PromotionElement>> getMyGiftCard({
    int? limit,
    int? page,
    String? search,
  }) async {
    Map<String, dynamic> data = {};

    if (limit != null) data["limit"] = limit;
    if (page != null) data["page"] = page;
    if (search != null) data["searchTerm"] = search;

    List<PromotionElement> giftCardList = [];

    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.myGiftCard,
        queryParameters: data,
      );

      AppPrint.apiResponse(response, title: "Get My Gift Card Full Response");

      if (response != null) {
        /// 👉 Directly parse using main model
        final model = MyGiftCardModel.fromJson(response);

        if (model.success == true &&
            model.data != null &&
            model.data!.promotions != null) {
          giftCardList = model.data!.promotions!;

          AppPrint.apiResponse(
            giftCardList,
            title: "Parsed PromotionElement List",
          );
        } else {
          AppSnackBar.error(model.message ?? "Failed to load gift cards");
        }
      } else {
        AppSnackBar.error("No response received");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get My Gift Card DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get My Gift Card DioException: ${error.message}");
      }
    } catch (e) {
      errorLog("getMyGiftCard", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get My Gift Card Error");
    }

    return giftCardList;
  }

  //--------------Privicy Policy Section--------------
  Future<String?> getRules(String endPoint) async {
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.ruls(endPoint),
      );
      if (response != null && response["data"] != null) {
        return response["data"]["content"];
      } else {
        AppSnackBar.error("Failed to load content");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Rules DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get Rules DioException: ${error.message}");
      }
      return null;
    } catch (e) {
      errorLog("getRules", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Rules Error");
      return null;
    }
    return null;
  }

  // ----------- Notification Section -----------

  Future<List<NotificationList>> getNotification({
    int? limit,
    int? page,
  }) async {
    List<NotificationList> notificationList = <NotificationList>[];
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.notification,
        queryParameters: {"limit": limit, "page": page},
      );

      // Log full response for debugging
      AppPrint.apiResponse(response, title: "Get Notification Full Response");

      if (response != null) {
        if (response["data"] != null) {
          AppPrint.apiResponse(
            response["data"],
            title: "Get Notification Data",
          );

          // Check if notifications exists and is a list
          if (response["data"]["notifications"] != null &&
              response["data"]["notifications"] is List) {
            AppPrint.apiResponse(
              response["data"]["notifications"],
              title: "Get Notification List",
            );

            for (var notification in response["data"]["notifications"]) {
              try {
                notificationList.add(NotificationList.fromJson(notification));
              } catch (e) {
                AppPrint.appError(e, title: "Notification Parse Error");
              }
            }
          } else {
            AppPrint.appError(
              "notifications is null or not a list",
              title: "Get Notification Error",
            );
            AppSnackBar.error("Failed to load notifications");
          }
        } else {
          AppPrint.appError(
            "Response data is null",
            title: "Get Notification Error",
          );
          AppSnackBar.error("Invalid response format");
        }
      } else {
        AppPrint.appError(
          "API response is null",
          title: "Get Notification Error",
        );
        AppSnackBar.error("No response received");
      }
    } on DioException catch (error) {
      String errorMessage = "Something went wrong";

      if (error.response != null && error.response?.data != null) {
        var responseData = error.response?.data;

        if (responseData is Map) {
          if (responseData["errorMessages"] != null &&
              responseData["errorMessages"] is List &&
              responseData["errorMessages"].isNotEmpty) {
            var firstError = responseData["errorMessages"][0];
            errorMessage = firstError is Map
                ? (firstError["message"] ?? firstError.toString())
                : firstError.toString();
          } else if (responseData["message"] != null) {
            errorMessage = responseData["message"].toString();
          } else if (responseData["error"] != null) {
            errorMessage = responseData["error"].toString();
          }
        } else if (responseData is String) {
          errorMessage = responseData;
        }

        AppSnackBar.error(errorMessage);
        AppPrint.appError(
          "Get Notification DioException [${error.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = "Network error. Please check your connection.";
        AppSnackBar.error(errorMessage);
        AppPrint.appError("Get Notification DioException: ${error.message}");
      }
    } catch (e) {
      errorLog("getNotification", e);
      AppSnackBar.error("An unexpected error occurred");
      AppPrint.appError(e, title: "Get Notification Error");
    }
    return notificationList;
  }

  Future<List<NearByMerchentModelData>> getNearbyMerchant({
    double? distance,
  }) async {
    List<NearByMerchentModelData> merchantList = <NearByMerchentModelData>[];
    Map<String, dynamic> data = {};
    if (distance != null) {
      // data["radius"] = distance;
    }
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.nearByMerchent,
        queryParameters: data,
      );
      if (response != null && response["data"] != null) {
        if (response["data"] is List) {
          return (response["data"] as List)
              .map((e) => NearByMerchentModelData.fromJson(e))
              .toList();
        } else if (response["data"] is Map &&
            response["data"]["merchants"] != null) {
          // Fallback if the structure is indeed nested as originally thought but data itself was map
          return (response["data"]["merchants"] as List)
              .map((e) => NearByMerchentModelData.fromJson(e))
              .toList();
        }
      } else {
        AppSnackBar.error("Failed to load merchants");
      }
    } catch (e) {
      AppPrint.appError(e, title: "Get Nearby Merchant Error");
    }
    return merchantList;
  }

  Future<List<PackageModel>> getPackageList() async {
    List<PackageModel> packageList = <PackageModel>[];
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.packageList,
      );
      if (response != null && response["data"] != null) {
        if (response["data"] is List) {
          return (response["data"] as List)
              .map((e) => PackageModel.fromJson(e))
              .toList();
        }
      } else {
        AppSnackBar.error("Failed to load packages");
      }
    } catch (e) {
      AppPrint.appError(e, title: "Get Package List Error");
    }
    return packageList;
  }

  Future<UserSummaryData?> getSubscriptionSummary() async {
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.subscriptionSummary,
      );

      if (response != null && response["data"] != null) {
        return UserSummaryData.fromJson(response["data"]);
      } else {
        AppSnackBar.error("Failed to load subscription summary");
        return null;
      }
    } catch (e) {
      AppPrint.appError(e, title: "Get Subscription Summary Error");
    }
    return null;
  }

  /// Poll a Kuickpay order until the backend has it as "completed".
  /// Used as a fallback while we wait for Kuickpay's server-to-server IPN.
  Future<String?> getKuickpayOrderStatus({required String orderId}) async {
    try {
      final response = await apiServices.apiGetServices(
        "${AppApiEndPoint.instance.kuickpayOrderStatus}/$orderId",
      );
      if (response != null && response["data"] != null) {
        return response["data"]["status"]?.toString();
      }
    } catch (e) {
      AppPrint.appError(e, title: "Get Kuickpay Order Status Error");
    }
    return null;
  }

  Future<ReferralSummaryData?> getReferralSummary() async {
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.instance.referralSummary,
      );

      if (response != null && response["data"] != null) {
        return ReferralSummaryData.fromJson(response["data"]);
      } else {
        AppSnackBar.error("Failed to load referral summary");
        return null;
      }
    } catch (e) {
      AppPrint.appError(e, title: "Get Referral Summary Error");
    }
    return null;
  }

  // ---------------- Subscription History ----------------

  Future<List<SubscriptionHistoryModelData>> getSubscriptionHistory({
    required String userId,
  }) async {
    List<SubscriptionHistoryModelData> subModelList =
    <SubscriptionHistoryModelData>[];
    try {
      final response = await apiServices.apiGetServices(
        "${AppApiEndPoint.instance.packageHistory}/$userId",
      );
      if (response != null && response["data"] != null) {
        for (var item in response["data"]) {
          subModelList.add(SubscriptionHistoryModelData.fromJson(item));
        }
      } else {
        AppSnackBar.error("Failed to load subscription history");
      }
    } catch (e) {
      AppPrint.appError(e, title: "Get Subscription History Error");
    }
    return subModelList;
  }

  // ---------------- Tiar List ----------------
  Future<List<TiarDataModel>> getTiarList({required String endPoint}) async {
    List<TiarDataModel> tiarList = <TiarDataModel>[];
    try {
      final response = await apiServices.apiGetServices(
        AppApiEndPoint.tiarList(endPoint),
      );
      if (response != null && response["data"] != null) {
        for (var item in response["data"]) {
          tiarList.add(TiarDataModel.fromJson(item));
        }
      }
    } catch (e) {
      AppPrint.appError(e, title: "Get Tiar List Error");
    }
    return tiarList;
  }
}