import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/repository/auth_repository.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_input/app_input_widget_two.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class EnterReffalIdScreen extends StatefulWidget {
  const EnterReffalIdScreen({super.key});

  @override
  State<EnterReffalIdScreen> createState() => _EnterReffalIdScreenState();
}

class _EnterReffalIdScreenState extends State<EnterReffalIdScreen> {
  // >>>>>>>>>>>>>> Form Key <<<<<<<<<<<<<<
  final GlobalKey<FormState> _refFormKey = GlobalKey<FormState>();

  // >>>>>>>>>>>>>> Controller <<<<<<<<<<<<<<
  late TextEditingController reffalIdController;

  @override
  void initState() {
    super.initState();
    reffalIdController = TextEditingController();
  }

  @override
  void dispose() {
    reffalIdController.dispose();
    super.dispose();
  }

  void verifyReffalId() async {
    AppPrint.apiResponse("verifyReffalId", title: "verifyReffalId");
    final response = await AuthRepository.instance.referralVerify(
      ref: reffalIdController.text,
    );

    if (response) {
      Get.toNamed(
        AppRoutes.instance.signUpScreen,
        arguments: reffalIdController.text,
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SignUpScreen()),
      // );
    } else {
      AppSnackBar.error("Invalid Referral ID");
    }
  }

  // >>>>>>>>>>>>>> Continue Button Validation <<<<<<<<<<<<<<
  void onContinue() {
    if (_refFormKey.currentState!.validate()) {
      // If valid - next page
      AppPrint.apiResponse("onContinue", title: "onContinue");
      verifyReffalId();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfacePrimaryLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                AppImage(path: AssetsPath.backgroundImage),
                Positioned(
                  left: AppSize.width(value: 12),
                  top: AppSize.size.height * 0.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        data: "Join Miltech Today!",
                        fontSize: AppSize.width(value: 34),
                        fontWeight: FontWeight.w700,
                        color: AppColor.button1Light,
                      ),
                      AppText(
                        data: "Unlock Rewards, Start Earning Now!",
                        fontSize: AppSize.width(value: 18),
                        fontWeight: FontWeight.w400,
                        color: AppColor.button1Light,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: AppSize.size.height * 0.2,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AppText(
                      data: "Logo",
                      fontSize: AppSize.width(value: 80),
                      fontWeight: FontWeight.w600,
                      color: AppColor.button1Light,
                    ),
                  ),
                ),
              ],
            ),

            Gap(height: AppSize.width(value: 30)),

            // >>>>>>>>>>>> Form Section <<<<<<<<<<<<<<<<
            Padding(
              padding: EdgeInsets.all(AppSize.width(value: 12)),
              child: Form(
                key: _refFormKey,
                child: Column(
                  spacing: AppSize.size.height * 0.03,
                  children: [
                    AppInputWidgetTwo(
                      borderRadius: 30,
                      hintText: "Enter Referral ID",
                      controller: reffalIdController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your referral ID';
                        }
                        // if (value.length < 4) {
                        //   return 'Referral ID must be at least 4 characters';
                        // }
                        return null;
                      },
                    ),

                    // >>>>>>> Continue Button <<<<<<<<
                    AppButton(
                      onTap: onContinue,
                      title: "Continue",
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // >>>>>>>>>>>>>>> Bottom Navigation <<<<<<<<<<<<<<
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSize.width(value: 12)),
          child: Row(
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    data: "Don't have a Referral ID?",
                    fontSize: AppSize.width(value: 12),
                    fontWeight: FontWeight.w700,
                    color: AppColor.button1Dark,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: AppText(
                      data: "Go Back",
                      fontSize: AppSize.width(value: 22),
                      fontWeight: FontWeight.w700,
                      color: AppColor.button5Dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
