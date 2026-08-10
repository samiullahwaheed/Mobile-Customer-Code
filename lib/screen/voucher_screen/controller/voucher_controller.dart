import 'package:get/get.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/model/my_gift_card_model.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class VoucherController extends GetxController {
  PromotionElement? promotion;
  RxBool isLoading = false.obs;
  PostRepository postRepository = PostRepository.instance;
  @override
  void onInit() {
    _getPromotionData();
    super.onInit();
  }

  void _getPromotionData() {
    promotion = Get.arguments as PromotionElement?;
    AppPrint.apiResponse("promotion: ${promotion?.promotion?.image}");
    if (promotion == null || promotion?.promotion?.id == null) {
      Get.back();
    }
  }
}
