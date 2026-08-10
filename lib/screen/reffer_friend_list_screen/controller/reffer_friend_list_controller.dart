import 'package:get/get.dart';
import 'package:loyalty_customer/screen/reffer_friend_list_screen/model/referral_summary_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';

class RefferFriendListController extends GetxController {
  GetRepository getRepository = GetRepository.instance;
  Rxn<ReferralSummaryData> referralSummaryData = Rxn<ReferralSummaryData>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getReferralSummary();
  }

  void getReferralSummary() async {
    isLoading.value = true;
    final response = await getRepository.getReferralSummary();

    if (response != null) {
      referralSummaryData.value = response;
    }

    isLoading.value = false;
  }
}
