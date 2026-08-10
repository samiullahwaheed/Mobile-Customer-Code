import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/privicy_screen/controller/privicy_policy_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class PrivicyScreen extends StatelessWidget {
  const PrivicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = Get.arguments['name'];
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<PrivicyPolicyController>(
      init: PrivicyPolicyController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(appThemeColor: appThemeColor, text: name),
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return controller.content == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage(
                          width: AppSize.size.width * 0.6,
                          path: AssetsPath.emptyTarmImg,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Html(
                        data: controller.content,
                        style: {
                          "body": Style(
                            color: appThemeColor.text2,
                            fontSize: FontSize(14),
                          ),
                          "p": Style(color: appThemeColor.text2),
                          "span": Style(color: appThemeColor.text2),
                          "li": Style(color: appThemeColor.text2),
                          "h1": Style(color: appThemeColor.text2),
                          "h2": Style(color: appThemeColor.text2),
                          "h3": Style(color: appThemeColor.text2),
                        },
                      ),
                    ),
                  );
          }),
        );
      },
    );
  }
}
