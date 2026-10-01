import 'package:get/get.dart';
import 'package:loyalty_customer/model/merchant_tiar_model.dart';
import 'package:loyalty_customer/screen/home_screen/controller/home_controller.dart';
import 'package:loyalty_customer/screen/home_screen/model/promotion_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class SinglePromoAndRewardController extends GetxController {
  Promotion? promotion;

  PostRepository postRepository = PostRepository.instance;
  GetRepository getRepository = GetRepository.instance;
  Rxn<MerchantTiarModelData> tiar = Rxn<MerchantTiarModelData>();
  RxBool isLoading = false.obs;
  RxBool isLoadingFetchMerchantTiar = false.obs;
  Future<void> addToWallet() async {
    isLoading.value = true;
    final response = await postRepository.addToWallet(
      promotionId: promotion?.id ?? "",
    );
    if (response) {
      AppPrint.apiResponse("Promotion added to wallet");
      // Opened from merchant details too, where Home may not be registered
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.promotionList.removeWhere(
          (element) => element.id == promotion?.id,
        );
        homeController.recentViewedPromotionList.removeWhere(
          (element) => element.id == promotion?.id,
        );
      }
      AppSnackBar.success("Promotion added to wallet");
      // true tells the opening screen the promotion is now in the wallet
      Get.back(result: true);
    } else {
      AppPrint.appError("Failed to add promotion to wallet");
    }
    isLoading.value = false;
  }

  void fetchMerchantTiar() async {
    // Tier belongs to the promotion's merchant, not the promotion
    final merchantId = promotion?.merchantId?.id;
    if (merchantId == null || merchantId.isEmpty) return;
    isLoadingFetchMerchantTiar.value = true;
    final response = await getRepository.getMerchantTiar(
      merchantId: merchantId,
    );
    if (response != null) {
      tiar.value = response;
    } else {
      AppPrint.appError("No Merchant Tiar Found");
    }
    isLoadingFetchMerchantTiar.value = false;
  }

  Future<void> addRecentViewedPromotion() async {
    if (promotion?.id == null) return;

    final response = await postRepository.addRecentViewedPromotion(
      promotionId: promotion?.id ?? "",
    );
    if (response) {
      AppPrint.apiResponse("Promotion added to recent viewed");
    } else {
      AppPrint.appError("Failed to add promotion to recent viewed");
    }
  }

  bool? isButtonVisible;

  @override
  void onInit() {
    promotion = Get.arguments["promotion"] as Promotion?;
    isButtonVisible = Get.arguments["button"] as bool? ?? true;
    if (promotion != null) {
      AppPrint.apiResponse("Promotion: $isButtonVisible");
    }

    fetchMerchantTiar();
    addRecentViewedPromotion();
    super.onInit();
  }
}
