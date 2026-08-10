import 'package:get/get.dart';
import 'package:loyalty_customer/screen/home_screen/model/promotion_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/error_log.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class SpecificServiceController extends GetxController {
  GetRepository getRepository = GetRepository.instance;
  PostRepository postRepository = PostRepository.instance;
  RxList<Promotion> specificPromotionList = <Promotion>[].obs;
  Rxn<String> loadingPromotionId = Rxn<String>();
  RxBool isLoading = false.obs;
  String categoryName = "";
  @override
  void onInit() {
    super.onInit();
    categoryName = Get.arguments;
    fetchSpecificPromotion();
  }

  void fetchSpecificPromotion() async {
    try {
      isLoading.value = true;
      final response = await getRepository.getSpecificPromotion(
        categoryName: categoryName,
      );
      if (response.isNotEmpty) {
        specificPromotionList.value = response;
      } else {
        AppPrint.appError(response, title: "Specific Promotion Error");
      }
    } catch (e) {
      errorLog("fetchSpecificPromotion", e);
    } finally {
      isLoading.value = false;
    }
  }

  //--------------Add Promotion to Wallet--------------
  //----------Add Promotion----------
  void addPromotionToWallet({required String promotionId}) async {
    loadingPromotionId.value = promotionId;
    final response = await postRepository.addToWallet(promotionId: promotionId);
    if (response) {
      AppPrint.apiResponse("Promotion added to wallet");
    } else {
      AppSnackBar.error("Failed to add promotion to wallet");
    }
    loadingPromotionId.value = null;
  }
}
