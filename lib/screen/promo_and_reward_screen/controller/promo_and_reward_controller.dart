import 'package:get/get.dart';
import 'package:loyalty_customer/screen/home_screen/model/promotion_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class PromoAndRewardController extends GetxController {
  //----------Dependencies----------
  GetRepository getRepository = GetRepository.instance;
  PostRepository postRepository = PostRepository.instance;
  //----------Variables----------
  RxList<Promotion> promotionList = <Promotion>[].obs;
  RxBool isLoading = false.obs;
  Rxn<String> loadingPromotionId = Rxn<String>();
  //----------Initial----------
  @override
  void onInit() {
    super.onInit();
    fetchPromotion();
  }

  //----------Fetch Promotion----------
  void fetchPromotion() async {
    isLoading.value = true;
    final response = await getRepository.getPromotion(100, 1);
    if (response.isNotEmpty) {
      promotionList.assignAll(response);
    } else {
      promotionList.clear();
      AppPrint.appError("No Promotion Found");
    }
    isLoading.value = false;
  }

  void reset() {
    fetchPromotion();
  }

  //----------Add Promotion----------
  void addPromotionToWallet({required String promotionId}) async {
    loadingPromotionId.value = promotionId;
    final response = await postRepository.addToWallet(promotionId: promotionId);
    if (response) {
      promotionList.removeWhere((element) => element.id == promotionId);
      promotionList.refresh();
      AppPrint.apiResponse("Promotion added to wallet");
    } else {
      AppSnackBar.error("Failed to add promotion to wallet");
    }
    loadingPromotionId.value = null;
  }
}
