import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/model/merchant_tiar_model.dart';
import 'package:loyalty_customer/screen/my_gift_card_screen/model/transaction_history_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class MyGiftCardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Rxn<DigitalCard> digitalCard = Rxn<DigitalCard>();
  String? digitalCardId;
  String? merchantId;
  String? merchantName;
  String? cardCode;
  String? image;
  double? point;

  GetRepository getRepository = GetRepository.instance;
  PostRepository postRepository = PostRepository.instance;
  Rxn<MerchantTiarModelData> merchantTiar = Rxn<MerchantTiarModelData>();

  RxBool isLoading = false.obs;

  RxList<TransactionHistoryModelData> transactionHistoryList =
      <TransactionHistoryModelData>[].obs;

  RxDouble ratingValue = 0.0.obs;
  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void updateRating({
    required double value,
    required String promotionId,
    required String merchantId,
    required String digitalCardId,
  }) {
    ratingValue.value = value;
  }

  void rateMerchant({
    required String digitalCardId,
    required String promotionId,
    required String merchantId,
    required double rating,
  }) async {
    final response = await postRepository.rateMerchant(
      digitalCardId: digitalCardId,
      promotionId: promotionId,
      merchantId: merchantId,
      rating: rating,
      comment: commentController.text,
    );

    if (response) {
      // 🔥 1. Find transaction
      final index = transactionHistoryList.indexWhere(
        (e) =>
            e.digitalCardId == digitalCardId &&
            e.promotionId == promotionId &&
            e.merchantId == merchantId,
      );

      // 🔥 2. Update rating manually
      if (index != -1) {
        transactionHistoryList[index].rating = rating;
        transactionHistoryList.refresh(); // UI update
      }

      commentController.clear();
      ratingValue.value = 0.0;

      AppPrint.apiResponse("Merchant Rated Successfully");
    } else {
      AppPrint.appError("Failed to Rate Merchant");
    }
  }

  late TabController tabController;

  RxInt currentTabIndex = 0.obs;
  void fetchTransactionHistory({String? type}) async {
    transactionHistoryList.clear();
    if (digitalCardId == null) return;
    isLoading.value = true;

    String transactionType = type ?? _getTransactionType(currentTabIndex.value);

    final response = await getRepository.getTransactionHistory(
      digitalCardId: digitalCardId ?? "",
      type: transactionType,
    );
    if (response.isNotEmpty) {
      transactionHistoryList.assignAll(response);
    } else {
      AppPrint.appError("No Transaction History Found");
    }
    isLoading.value = false;
  }

  String _getTransactionType(int index) {
    switch (index) {
      case 0:
        return "all";
      case 1:
        return "earn";
      case 2:
        return "use";
      default:
        return "all";
    }
  }

  void onTabChanged() {
    currentTabIndex.value = tabController.index;
    fetchTransactionHistory();
  }

  void fetchMerchantTiar() async {
    if (merchantId == null) return;

    isLoading.value = true;
    final response = await getRepository.getMerchantTiar(
      merchantId: merchantId ?? "",
    );
    if (response != null) {
      merchantTiar.value = response;
    } else {
      AppPrint.appError("No Merchant Tiar Found");
    }
    // isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    commentController = TextEditingController();
    _getData();

    // Initialize TabController
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(onTabChanged);

    fetchTransactionHistory();
    fetchMerchantTiar();
  }

  void _getData() {
    digitalCardId = Get.arguments["digitalCardId"];
    merchantId = Get.arguments["merchantId"];
    merchantName = Get.arguments["merchantName"];
    cardCode = Get.arguments["cardCode"];
    image = Get.arguments["image"];
    point = Get.arguments["point"];
  }

  @override
  void onClose() {
    tabController.removeListener(onTabChanged);
    tabController.dispose();
    super.onClose();
  }
}
