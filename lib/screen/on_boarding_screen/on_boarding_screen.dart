import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/on_boarding_screen/controller/on_boarding_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      backgroundColor: AppColor.surfacePrimaryLight,
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingSection(
                imamePath: AssetsPath.onBoard1,
                title: "Welcome to Rewaldo!",
                subTitle:
                    "Every purchase brings you closer to exclusive benefits.",
                wedth: AppSize.size.width * 0.8,
                height: AppSize.size.height * 0.25,
              ),
              OnBoardingSection(
                imamePath: AssetsPath.onBoard2,
                title: "Earn Rewards",
                subTitle:
                    "Earn rewards with every purchase. Get started today and unlock exclusive benefits!",
                wedth: 250,
                height: 250,
                // wedth: AppSize.size.width * 0.8,
                // height: AppSize.size.height * 0.25,
              ),
              OnBoardingSection(
                imamePath: AssetsPath.onBoard3,
                title: "Refer a Friend, Get Rewarded!",
                subTitle:
                    "Refer your friends to Rewaldo and introduce them to a world of exclusive benefits. You'll get rewarded, and so will they!",
                // wedth: AppSize.size.width * 0.8,
                // height: AppSize.size.height * 0.25,
                wedth: 265,
                height: 265,
              ),
            ],
          ),
          OnboadingDorNavigation(),

          Obx(() {
            return OnBoardingController.instance.currentPageIndex.value != 2
                ? OnBoardingSkipBtn()
                : SizedBox.shrink();
          }),
          OnBoaringNavigationBtn(),
        ],
      ),
    );
  }
}

class OnBoardingSkipBtn extends StatelessWidget {
  const OnBoardingSkipBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      top: 40,
      child: InkWell(
        onTap: () => OnBoardingController.instance.skipPage(),
        child: AppText(
          data: "Skip",
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class OnBoaringNavigationBtn extends StatelessWidget {
  const OnBoaringNavigationBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 10,
      child: Obx(() {
        return AppButton(
          onTap: () => OnBoardingController.instance.nextPage(),
          width: AppSize.width(value: 100),
          title: OnBoardingController.instance.currentPageIndex.value == 2
              ? "Get Started"
              : "Next",
        );
      }),
    );
  }
}

class OnboadingDorNavigation extends StatelessWidget {
  const OnboadingDorNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Positioned(
      left: 10,
      bottom: 36,

      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: AppColor.button5Light,
          dotHeight: 6,
        ),
      ),
    );
  }
}

class OnBoardingSection extends StatelessWidget {
  final double wedth;
  final double height;
  final String imamePath;
  final String title;
  final String subTitle;
  const OnBoardingSection({
    super.key,
    required this.imamePath,
    required this.title,
    required this.subTitle,
    required this.wedth,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            AppImage(path: AssetsPath.backgroundImage),

            Positioned(
              top: AppSize.size.height * 0.06,
              left: 0,
              right: 0, // Ensure that it's horizontally centered
              child: Center(
                // Center the text horizontally
                child: AppImage(width: wedth, path: imamePath, height: height),
              ),
            ),
          ],
        ),
        Gap(height: AppSize.width(value: 20)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppText(
                data: title,
                fontSize: AppSize.width(value: 30),
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                color: Colors.black,
              ),
              AppText(
                data: subTitle,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
