import 'package:get/get.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class RecentlyViewController extends GetxController {
  var favorites = <RxBool>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Initialize the favorites list with false for each merchant (for example, 4 merchants)
    favorites.addAll(List.generate(4, (_) => false.obs));
  }

  void toggoleFavorate(int index) {
    // Toggle the favorite status for the merchant at the specified index
    favorites[index].value = !favorites[index].value;
    AppPrint.apiResponse(index);
  }
}
