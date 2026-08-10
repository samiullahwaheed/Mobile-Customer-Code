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
  HomeController homeController = Get.find<HomeController>();
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
      homeController.promotionList.removeWhere(
        (element) => element.id == promotion?.id,
      );
      homeController.recentViewedPromotionList.removeWhere(
        (element) => element.id == promotion?.id,
      );
      AppSnackBar.success("Promotion added to wallet");
      Get.back();
    } else {
      AppPrint.appError("Failed to add promotion to wallet");
    }
    isLoading.value = false;
  }

  void fetchMerchantTiar() async {
    if (promotion?.id == null) return;
    isLoadingFetchMerchantTiar.value = true;
    final response = await getRepository.getMerchantTiar(
      merchantId: promotion?.id ?? "",
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
