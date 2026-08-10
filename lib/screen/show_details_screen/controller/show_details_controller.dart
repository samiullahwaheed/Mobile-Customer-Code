import 'package:get/get.dart';
import 'package:loyalty_customer/model/merchant_tiar_model.dart';
import 'package:loyalty_customer/screen/show_details_screen/model/merchant_details_model.dart';
import 'package:loyalty_customer/screen/show_details_screen/model/tiar_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class ShowDetailsController extends GetxController {
  GetRepository getRepository = GetRepository.instance;
  Rxn<String> loadingPromotionId = Rxn<String>();
  PostRepository postRepository = PostRepository.instance;
  Rxn<MerchantTiarModelData> merchantTiar = Rxn<MerchantTiarModelData>();

  Rxn<List<TiarDataModel>> tiarList = Rxn<List<TiarDataModel>>();

  RxBool isLoadingFetchMerchantTiar = false.obs;

  Rxn<MerchantDetailsModelData> merchantDetails =
      Rxn<MerchantDetailsModelData>();
  String merchantId = "";
  RxBool isLoading = false.obs;
  RxBool isLoadingAddCardForWallet = false.obs;
  void addCardForWallet() async {
    if (merchantId.isEmpty) return;
    try {
      isLoadingAddCardForWallet.value = true;
      final response = await postRepository.addCardForWallet(
        merchantId: merchantId,
      );
      if (response != null) {
        AppSnackBar.success("Card added to wallet");
        merchantDetails.value?.merchant?.digitalCardId = response.toString();
        AppPrint.apiResponse(response, title: "Card added to wallet");
        // important UI update

        merchantDetails.refresh();
      } else {
        AppPrint.appError("Failed to add card to wallet");
      }
    } catch (e) {
      errorLog("addCardForWallet", e);
    } finally {
      isLoadingAddCardForWallet.value = false;
    }
  }

  void fetchMerchantDetails() async {
    try {
      if (merchantId.isEmpty) return;
      isLoading.value = true;
      final response = await getRepository.getMerchantDetails(
        merchantId: merchantId,
      );
      if (response != null) {
        merchantDetails.value = response;
      } else {
        AppPrint.appError("No Merchant Details Found");
      }
    } catch (e) {
      errorLog("fetchMerchantDetails", e);
    } finally {
      isLoading.value = false;
    }
  }

  //----------Fetch Tiar List----------
  void fetchTiarList() async {
    try {
      final response = await getRepository.getTiarList(endPoint: merchantId);
      if (response.isNotEmpty) {
        tiarList.value = response;
        AppPrint.apiResponse("Tiar List Fetched");
      } else {
        AppPrint.appError("No Tiar List Found");
      }
    } catch (e) {
      errorLog("fetchTiarList", e);
    }
  }

  //----------Add Promotion----------
  void addPromotionToWallet({required String promotionId}) async {
    try {
      loadingPromotionId.value = promotionId;
      final response = await postRepository.addToWallet(
        promotionId: promotionId,
      );
      if (response) {
        merchantDetails.value?.promotions
                .firstWhere((element) => element.id == promotionId)
                .buy =
            true;
        AppSnackBar.success("Promotion added to wallet");
        merchantDetails.refresh();
        AppPrint.apiResponse("Promotion added to wallet");
      } else {
        AppSnackBar.error("Failed to add promotion to wallet");
      }
      loadingPromotionId.value = null;
    } catch (e) {
      errorLog("addPromotionToWallet", e);
    }
  }

  void fetchMerchantTiar() async {
    try {
      if (merchantId.isEmpty) return;
      final response = await getRepository.getMerchantTiar(
        merchantId: merchantId,
      );
      if (response != null) {
        merchantTiar.value = response;
      } else {
        AppPrint.appError("No Merchant Tiar Found");
      }
    } catch (e) {
      errorLog("fetchMerchantTiar", e);
    }
  }

  @override
  void onInit() {
    merchantId = Get.arguments as String;
    fetchMerchantDetails();
    fetchMerchantTiar();
    fetchTiarList();
    super.onInit();
  }
}
