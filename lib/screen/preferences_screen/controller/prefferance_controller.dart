import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class PreferenceItem {
  final String title;
  final String imageUrl;

  const PreferenceItem({required this.title, required this.imageUrl});
}

class PrefferanceController extends GetxController {
  final RxSet<int> selectedIndices = <int>{}.obs;
  final RxList<String> selectedTitles = <String>[].obs;

  PostRepository postRepository = PostRepository.instance;

  final List<PreferenceItem> items = const [
    PreferenceItem(
      title: 'Food and Beverages',
      imageUrl:
          'https://cdn.pixabay.com/photo/2022/09/05/09/23/spaghetti-7433732_640.jpg',
    ),
    PreferenceItem(
      title: 'Apparel and Footwear',
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/04/06/01/45/chair-7902575_640.jpg',
    ),
    PreferenceItem(
      title: 'Accessories',
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/08/02/01/34/pocket-watch-2569573_640.jpg',
    ),
    PreferenceItem(
      title: 'Health and Beauty',
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/11/14/23/06/beauty-8388873_640.jpg',
    ),
    PreferenceItem(
      title: 'Salons and Spas',
      imageUrl:
          'https://cdn.pixabay.com/photo/2024/04/26/19/30/spa-8722520_640.jpg',
    ),
    PreferenceItem(
      title: 'Leisure and Entertainment',
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/06/10/22/48/chess-3467512_640.jpg',
    ),
    PreferenceItem(
      title: 'Home and Living',
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/08/27/10/16/interior-2685521_640.jpg',
    ),
    PreferenceItem(
      title: 'Education',
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/08/06/22/01/books-2596809_1280.jpg',
    ),
    PreferenceItem(
      title: 'Electronics',
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/05/08/08/44/artificial-intelligence-3382507_640.jpg',
    ),
    PreferenceItem(
      title: 'Toys and Gifts',
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193_640.jpg',
    ),
    PreferenceItem(
      title: 'Travel and Tour',
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/04/16/11/41/waterfall-5050298_640.jpg',
    ),
    PreferenceItem(
      title: 'Other Services',
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/10/15/10/52/e-mail-489518_640.png',
    ),
  ];

  bool isSelected(int index) => selectedIndices.contains(index);

  void toggleIndex(int index) {
    final title = items[index].title;

    if (isSelected(index)) {
      selectedIndices.remove(index);
      selectedTitles.remove(title);
    } else {
      selectedIndices.add(index);
      selectedTitles.add(title);
      AppPrint.apiResponse(selectedTitles);
    }
  }

  void updatePreferences() async {
    if (selectedTitles.isEmpty) {
      AppSnackBar.error("Please select at least one preference");
      return;
    }
    final response = await postRepository.updateUserProfile(
      prefreances: selectedTitles,
    );
    if (response) {
      Get.offAllNamed(AppRoutes.instance.mySubScreen , arguments: {
        'value': 2,
      });
      // Get.offAllNamed(AppRoutes.instance.navigationScreen);
    } else {
      AppSnackBar.error("Failed to update preferences");
    }
  }
}
