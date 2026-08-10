import 'package:get/get.dart';
import 'package:loyalty_customer/screen/transaction_history_screen/model/transection_history_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class TransactionHistoryController extends GetxController {
  GetRepository getRepository = GetRepository.instance;
  RxList<SubscriptionHistoryModelData> subscriptionHistoryList =
      <SubscriptionHistoryModelData>[].obs;
  RxBool isLoading = false.obs;
  String? userId;
  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments;
    getTransactionHistory();
  }

  Future<void> getTransactionHistory() async {
    try {
      isLoading.value = true;
      final response = await getRepository.getSubscriptionHistory(
        userId: userId ?? "",
      );
      if (response.isNotEmpty) {
        subscriptionHistoryList.value = response;
      }
    } catch (e) {
      AppPrint.appError(e, title: "Get Transaction History Error");
    } finally {
      isLoading.value = false;
    }
  }
}
